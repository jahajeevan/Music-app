import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// Invoked by a scheduled Supabase cron job on the 1st of each month.
// Calculates royalties for the previous month and inserts into royalty_ledger.
// Uses a simplified per-stream rate model; production would use pro-rata pooling.

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

// Payout rate per quality tier (USD cents per completed stream)
const PAYOUT_RATES: Record<string, number> = {
  normal: 0.03,       // $0.0003
  high: 0.04,
  very_high: 0.05,
  lossless: 0.07,
  hi_res_lossless: 0.10,
  spatial: 0.12,
};

// A stream must reach at least 30 seconds to count for royalties
const MIN_PLAY_MS = 30_000;

serve(async (req) => {
  const authHeader = req.headers.get('Authorization');
  const cronSecret = Deno.env.get('CRON_SECRET');
  if (cronSecret && authHeader !== `Bearer ${cronSecret}`) {
    return new Response('Unauthorized', { status: 401 });
  }

  const now = new Date();
  const periodEnd = new Date(now.getFullYear(), now.getMonth(), 1); // 1st of this month (=end of last)
  const periodStart = new Date(periodEnd.getFullYear(), periodEnd.getMonth() - 1, 1); // 1st of last month

  const periodStartStr = periodStart.toISOString().slice(0, 10);
  const periodEndStr = periodEnd.toISOString().slice(0, 10);

  console.log(`Calculating royalties for ${periodStartStr} → ${periodEndStr}`);

  // Aggregate streams from play_events for the period
  const { data: streamAgg, error } = await supabase.rpc('aggregate_streams_for_period', {
    p_start: periodStartStr,
    p_end: periodEndStr,
    p_min_play_ms: MIN_PLAY_MS,
  });

  if (error) {
    console.error('Failed to aggregate streams:', error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  if (!streamAgg || streamAgg.length === 0) {
    return new Response(JSON.stringify({ message: 'No streams to process', period: periodStartStr }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  // Build royalty ledger entries
  const ledgerEntries = streamAgg.map((row: {
    track_id: string;
    artist_id: string;
    stream_count: number;
    stream_ms: number;
    quality: string;
  }) => {
    const rate = PAYOUT_RATES[row.quality] ?? PAYOUT_RATES.normal;
    const grossCents = Math.round(row.stream_count * 100 * rate);  // rate in cents
    const royaltyRate = 0.52;  // artist receives 52% of gross (industry ~50-55%)
    const payoutCents = Math.round(grossCents * royaltyRate);

    return {
      track_id: row.track_id,
      artist_id: row.artist_id,
      period_start: periodStartStr,
      period_end: periodEndStr,
      stream_count: row.stream_count,
      stream_ms: row.stream_ms,
      gross_usd_cents: grossCents,
      royalty_rate: royaltyRate,
      payout_usd_cents: payoutCents,
      is_paid: false,
    };
  });

  // Upsert in chunks of 500
  const CHUNK = 500;
  let totalInserted = 0;
  for (let i = 0; i < ledgerEntries.length; i += CHUNK) {
    const chunk = ledgerEntries.slice(i, i + CHUNK);
    const { error: insertErr } = await supabase.from('royalty_ledger').upsert(chunk, {
      onConflict: 'track_id,period_start',
    });
    if (insertErr) {
      console.error('Insert error at chunk', i, insertErr);
    } else {
      totalInserted += chunk.length;
    }
  }

  const totalPayout = ledgerEntries.reduce((sum: number, e: { payout_usd_cents: number }) => sum + e.payout_usd_cents, 0);

  console.log(`Royalty calculation complete: ${totalInserted} entries, $${(totalPayout / 100).toFixed(2)} total payout`);

  return new Response(
    JSON.stringify({
      period: `${periodStartStr} to ${periodEndStr}`,
      entries: totalInserted,
      total_payout_cents: totalPayout,
    }),
    { status: 200, headers: { 'Content-Type': 'application/json' } },
  );
});
