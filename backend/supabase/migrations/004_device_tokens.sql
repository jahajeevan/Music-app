-- ============================================================
-- 004_device_tokens.sql
-- FCM / APNs device tokens for push notifications
-- ============================================================

create table device_tokens (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references user_profiles(id) on delete cascade,
  fcm_token  text not null,
  platform   text not null,    -- 'ios' | 'android' | 'web'
  is_active  boolean default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, fcm_token)
);

create index on device_tokens(user_id, is_active);
create index on device_tokens(fcm_token);

alter table device_tokens enable row level security;

create policy "users manage own device tokens"
  on device_tokens for all
  using (auth.uid() = user_id);

create trigger device_tokens_updated_at
  before update on device_tokens
  for each row execute function set_updated_at();

-- ─── Helper function for aggregate_streams_for_period ────────
-- Used by royalty-calculator Edge Function
create or replace function aggregate_streams_for_period(
  p_start date,
  p_end   date,
  p_min_play_ms int default 30000
)
returns table (
  track_id    uuid,
  artist_id   uuid,
  quality     text,
  stream_count bigint,
  stream_ms   bigint
)
language sql security definer
stable
as $$
  select
    pe.track_id,
    t.artist_id,
    pe.quality::text,
    count(*)       as stream_count,
    sum(pe.play_ms) as stream_ms
  from play_events pe
  join tracks t on t.id = pe.track_id
  where
    pe.played_at >= p_start::timestamptz
    and pe.played_at < p_end::timestamptz
    and pe.play_ms >= p_min_play_ms
  group by pe.track_id, t.artist_id, pe.quality
$$;
