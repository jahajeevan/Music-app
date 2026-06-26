import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// Dispatches push notifications for queued notification records.
// Can be invoked directly or via a Supabase database webhook on notifications insert.

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

const FCM_SERVER_KEY = Deno.env.get('FCM_SERVER_KEY') ?? '';

interface NotificationRecord {
  id: string;
  user_id: string;
  type: string;
  actor_id?: string;
  payload: Record<string, unknown>;
}

const notificationTemplates: Record<string, (actor: string, payload: Record<string, unknown>) => { title: string; body: string }> = {
  new_follower: (actor) => ({ title: 'New follower', body: `${actor} started following you` }),
  friend_liked: (actor, p) => ({ title: actor, body: `liked ${p.track_title ?? 'a track'}` }),
  friend_listening_party: (actor, p) => ({ title: `${actor} started a listening party`, body: String(p.party_title ?? 'Join now!') }),
  new_release: (_actor, p) => ({ title: 'New release', body: `${p.artist_name} just dropped "${p.track_title}"` }),
  comment: (actor, p) => ({ title: actor, body: `commented: "${String(p.comment_text ?? '').slice(0, 60)}"` }),
  reaction: (actor) => ({ title: actor, body: 'reacted to your post' }),
  party_invite: (actor, p) => ({ title: `${actor} invited you`, body: `Join "${p.party_title}" listening party` }),
  system: (_actor, p) => ({ title: 'Wavelength', body: String(p.message ?? 'You have a new notification') }),
};

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405 });
  }

  // Supabase database webhooks send the record in `record` field
  const body = await req.json();
  const notifications: NotificationRecord[] = body.record ? [body.record] : (body.notifications ?? []);

  if (!notifications.length) {
    return new Response(JSON.stringify({ dispatched: 0 }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  let dispatched = 0;

  for (const notif of notifications) {
    // Get actor name if there's an actor
    let actorName = 'Someone';
    if (notif.actor_id) {
      const { data: actor } = await supabase
        .from('user_profiles')
        .select('display_name, username')
        .eq('id', notif.actor_id)
        .single();
      actorName = actor?.display_name ?? actor?.username ?? 'Someone';
    }

    const template = notificationTemplates[notif.type];
    if (!template) continue;

    const { title, body: notifBody } = template(actorName, notif.payload);

    // Get user's FCM tokens
    const { data: tokens } = await supabase
      .from('device_tokens')
      .select('fcm_token')
      .eq('user_id', notif.user_id)
      .eq('is_active', true);

    if (!tokens || tokens.length === 0 || !FCM_SERVER_KEY) continue;

    const fcmTokens = tokens.map((t: { fcm_token: string }) => t.fcm_token);

    const fcmPayload = {
      registration_ids: fcmTokens,
      notification: {
        title,
        body: notifBody,
        sound: 'default',
        badge: '1',
      },
      data: {
        notification_id: notif.id,
        type: notif.type,
        ...Object.fromEntries(
          Object.entries(notif.payload).map(([k, v]) => [k, String(v)])
        ),
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    const fcmRes = await fetch('https://fcm.googleapis.com/fcm/send', {
      method: 'POST',
      headers: {
        'Authorization': `key=${FCM_SERVER_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(fcmPayload),
    });

    if (fcmRes.ok) {
      dispatched++;
    } else {
      console.error('FCM error for notification', notif.id, await fcmRes.text());
    }
  }

  return new Response(
    JSON.stringify({ dispatched }),
    { status: 200, headers: { 'Content-Type': 'application/json' } },
  );
});
