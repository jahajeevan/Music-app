import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { createHmac } from 'https://deno.land/std@0.177.0/node/crypto.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

const CDN_BASE = Deno.env.get('CDN_BASE_URL') ?? 'https://cdn.wavelength.fm';
const CDN_SECRET = Deno.env.get('CDN_SIGNING_SECRET') ?? '';
const URL_TTL_SECONDS = 3600; // 1 hour

// Quality → CDN path suffix mapping
const qualitySuffix: Record<string, string> = {
  normal: '_128.aac',
  high: '_256.aac',
  very_high: '_320.mp3',
  lossless: '_lossless.flac',
  hi_res_lossless: '_hires.flac',
  spatial: '_spatial.m4a',
};

// Tier → max allowed quality
const tierMaxQuality: Record<string, string[]> = {
  free: ['normal'],
  premium: ['normal', 'high', 'very_high', 'lossless'],
  premium_plus: ['normal', 'high', 'very_high', 'lossless', 'hi_res_lossless', 'spatial'],
  family: ['normal', 'high', 'very_high', 'lossless'],
  student: ['normal', 'high', 'very_high', 'lossless'],
  artist: ['normal', 'high', 'very_high', 'lossless'],
};

function signUrl(url: string, expiresAt: number): string {
  const payload = `${url}:${expiresAt}`;
  const signature = createHmac('sha256', CDN_SECRET)
    .update(payload)
    .digest('hex');
  return `${url}?expires=${expiresAt}&sig=${signature}`;
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const { track_id, quality = 'high' } = await req.json();
    if (!track_id) {
      return new Response(JSON.stringify({ error: 'track_id required' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Fetch track + user profile in parallel
    const [trackRes, profileRes] = await Promise.all([
      supabase.from('tracks').select('id, cdn_path, has_lossless, has_spatial, available_markets').eq('id', track_id).single(),
      supabase.from('user_profiles').select('subscription, country_code').eq('id', user.id).single(),
    ]);

    if (trackRes.error || !trackRes.data) {
      return new Response(JSON.stringify({ error: 'Track not found' }), {
        status: 404,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const track = trackRes.data;
    const profile = profileRes.data ?? { subscription: 'free', country_code: 'US' };

    // Market check
    if (track.available_markets.length > 0 && !track.available_markets.includes(profile.country_code)) {
      return new Response(JSON.stringify({ error: 'Track not available in your region' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Enforce quality tier
    const allowedQualities = tierMaxQuality[profile.subscription] ?? tierMaxQuality.free;
    let effectiveQuality = quality;
    if (!allowedQualities.includes(quality)) {
      // Downgrade to highest allowed
      effectiveQuality = allowedQualities[allowedQualities.length - 1];
    }

    // Check feature availability
    if (effectiveQuality === 'lossless' && !track.has_lossless) effectiveQuality = 'very_high';
    if (effectiveQuality === 'hi_res_lossless' && !track.has_lossless) effectiveQuality = 'very_high';
    if (effectiveQuality === 'spatial' && !track.has_spatial) effectiveQuality = 'very_high';

    const suffix = qualitySuffix[effectiveQuality] ?? qualitySuffix.high;
    const cdnPath = `${track.cdn_path}${suffix}`;
    const rawUrl = `${CDN_BASE}/${cdnPath}`;

    const expiresAt = Math.floor(Date.now() / 1000) + URL_TTL_SECONDS;
    const signedUrl = CDN_SECRET ? signUrl(rawUrl, expiresAt) : rawUrl;

    return new Response(
      JSON.stringify({
        url: signedUrl,
        quality: effectiveQuality,
        expires_at: expiresAt,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      },
    );
  } catch (err) {
    console.error('streaming-url error:', err);
    return new Response(JSON.stringify({ error: 'Internal server error' }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});
