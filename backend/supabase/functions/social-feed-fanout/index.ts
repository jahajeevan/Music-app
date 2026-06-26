import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// Called after an activity event is created (via database trigger or direct invoke).
// Fans out the activity to followers' notification queues and triggers push notifications.

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

const FCM_SERVER_KEY = Deno.env.get('FCM_SERVER_KEY') ?? '';

interface FanoutRequest {
  activity_id: string;
  user_id: string;
  type: string;
  track_id?: string;
  artist_id?: string;
  playlist_id?: string;
}

async function sendPushNotification(fcmTokens: string[], title: string, body: string, data: Record<string, string> = {}) {
  if (!FCM_SERVER_KEY || fcmTokens.length === 0) return;

  await fetch('https://fcm.googleapis.com/fcm/send', {
    method: 'POST',
    headers: {
      'Authorization': `key=${FCM_SERVER_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      registration_ids: fcmTokens,
      notification: { title, body },
      data,
    }),
  });
}

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405 });
  }

  const payload = await req.json() as FanoutRequest;
  const { activity_id, user_id, type } = payload;

  if (!activity_id || !user_id) {
    return new Response(JSON.stringify({ error: 'activity_id and user_id required' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  // Get the actor's display name and all followers
  const [profileRes, followersRes] = await Promise.all([
    supabase.from('user_profiles').select('display_name, username').eq('id', user_id).single(),
    supabase.from('follows').select('follower_id').eq('followee_id', user_id),
  ]);

  const actor = profileRes.data;
  const followers = followersRes.data ?? [];

  if (followers.length === 0) {
    return new Response(JSON.stringify({ fanned_out: 0 }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const followerIds = followers.map((f) => f.follower_id);

  // Build notification message based on activity type
  const actorName = actor?.display_name ?? actor?.username ?? 'Someone';
  let notifTitle = '';
  let notifBody = '';

  switch (type) {
    case 'liked_track':
      notifTitle = actorName;
      notifBody = 'liked a track';
      break;
    case 'created_playlist':
      notifTitle = actorName;
      notifBody = 'created a new playlist';
      break;
    case 'listening_party':
      notifTitle = `${actorName} started a listening party`;
      notifBody = 'Join in and listen together!';
      break;
    case 'shared_track':
      notifTitle = actorName;
      notifBody = 'shared a track with you';
      break;
    default:
      notifTitle = actorName;
      notifBody = 'has new activity';
  }

  // Create notifications for all followers (batch insert, max 500 per chunk)
  const CHUNK = 500;
  for (let i = 0; i < followerIds.length; i += CHUNK) {
    const chunk = followerIds.slice(i, i + CHUNK);
    const notifications = chunk.map((followerId) => ({
      user_id: followerId,
      type: 'friend_liked' as const,
      actor_id: user_id,
      payload: { activity_id, activity_type: type },
    }));
    await supabase.from('notifications').insert(notifications);
  }

  // Send push notifications via FCM (fetch device tokens for followers)
  const { data: tokens } = await supabase
    .from('device_tokens')
    .select('fcm_token')
    .in('user_id', followerIds)
    .eq('is_active', true);

  if (tokens && tokens.length > 0) {
    const fcmTokens = tokens.map((t: { fcm_token: string }) => t.fcm_token);
    // FCM supports up to 1000 tokens per request
    for (let i = 0; i < fcmTokens.length; i += 1000) {
      await sendPushNotification(
        fcmTokens.slice(i, i + 1000),
        notifTitle,
        notifBody,
        { type, activity_id },
      );
    }
  }

  return new Response(
    JSON.stringify({ fanned_out: followerIds.length }),
    { status: 200, headers: { 'Content-Type': 'application/json' } },
  );
});
