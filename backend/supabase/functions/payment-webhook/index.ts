import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import Stripe from 'https://esm.sh/stripe@14?target=deno';

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') ?? '', {
  apiVersion: '2024-04-10',
  httpClient: Stripe.createFetchHttpClient(),
});

const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET') ?? '';

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

// Map Stripe price IDs to our subscription tiers
async function getTierFromPriceId(priceId: string): Promise<string> {
  const { data } = await supabase
    .from('pricing_plans')
    .select('tier')
    .eq('stripe_price_id', priceId)
    .single();
  return data?.tier ?? 'free';
}

async function upsertSubscription(stripeSubscription: Stripe.Subscription, userId: string) {
  const item = stripeSubscription.items.data[0];
  const tier = await getTierFromPriceId(item.price.id);

  const subData = {
    user_id: userId,
    tier,
    status: stripeSubscription.status as string,
    provider: 'stripe' as const,
    provider_sub_id: stripeSubscription.id,
    provider_customer_id: stripeSubscription.customer as string,
    price_usd_cents: item.price.unit_amount ?? 0,
    currency: item.price.currency?.toUpperCase() ?? 'USD',
    billing_interval: item.price.recurring?.interval ?? 'month',
    trial_ends_at: stripeSubscription.trial_end ? new Date(stripeSubscription.trial_end * 1000).toISOString() : null,
    current_period_start: new Date(stripeSubscription.current_period_start * 1000).toISOString(),
    current_period_end: new Date(stripeSubscription.current_period_end * 1000).toISOString(),
    canceled_at: stripeSubscription.canceled_at ? new Date(stripeSubscription.canceled_at * 1000).toISOString() : null,
  };

  await supabase.from('subscriptions').upsert(subData, { onConflict: 'provider_sub_id' });

  // Mirror tier on user_profiles for fast reads (no join needed at query time)
  const profileTier = ['active', 'trialing'].includes(stripeSubscription.status) ? tier : 'free';
  const expiresAt = ['active', 'trialing'].includes(stripeSubscription.status)
    ? new Date(stripeSubscription.current_period_end * 1000).toISOString()
    : null;

  await supabase.from('user_profiles').update({
    subscription: profileTier,
    subscription_expires_at: expiresAt,
  }).eq('id', userId);
}

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405 });
  }

  const signature = req.headers.get('stripe-signature');
  if (!signature) {
    return new Response('No signature', { status: 400 });
  }

  const body = await req.text();
  let event: Stripe.Event;

  try {
    event = await stripe.webhooks.constructEventAsync(body, signature, webhookSecret);
  } catch (err) {
    console.error('Webhook signature verification failed:', err);
    return new Response('Invalid signature', { status: 400 });
  }

  // Log the raw event for auditability / replay
  await supabase.from('payment_events').insert({
    provider: 'stripe',
    event_type: event.type,
    payload: event as unknown as Record<string, unknown>,
  });

  try {
    switch (event.type) {
      case 'checkout.session.completed': {
        const session = event.data.object as Stripe.Checkout.Session;
        const userId = session.metadata?.user_id;
        if (!userId || !session.subscription) break;

        const sub = await stripe.subscriptions.retrieve(session.subscription as string);
        await upsertSubscription(sub, userId);
        break;
      }

      case 'customer.subscription.updated':
      case 'customer.subscription.deleted': {
        const sub = event.data.object as Stripe.Subscription;
        const customer = await stripe.customers.retrieve(sub.customer as string);
        if (customer.deleted) break;

        const { data: profile } = await supabase
          .from('user_profiles')
          .select('id')
          .eq('id', (customer as Stripe.Customer).metadata?.user_id)
          .single();

        if (!profile) break;
        await upsertSubscription(sub, profile.id);
        break;
      }

      case 'invoice.payment_failed': {
        const invoice = event.data.object as Stripe.Invoice;
        if (!invoice.subscription) break;

        const { data: sub } = await supabase
          .from('subscriptions')
          .select('user_id')
          .eq('provider_sub_id', invoice.subscription)
          .single();

        if (sub) {
          await supabase.from('subscriptions')
            .update({ status: 'past_due' })
            .eq('provider_sub_id', invoice.subscription);

          // Send in-app notification
          await supabase.from('notifications').insert({
            user_id: sub.user_id,
            type: 'system',
            payload: { message: 'Your payment failed. Please update your payment method.' },
          });
        }
        break;
      }

      default:
        // Unhandled event type — already logged above
        break;
    }

    // Mark event as processed
    await supabase.from('payment_events')
      .update({ processed: true })
      .eq('provider', 'stripe')
      .eq('payload->id', event.id);

  } catch (err) {
    console.error('Error processing webhook event:', err);
    await supabase.from('payment_events')
      .update({ error: String(err) })
      .eq('provider', 'stripe')
      .eq('payload->id', event.id);
  }

  return new Response(JSON.stringify({ received: true }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
});
