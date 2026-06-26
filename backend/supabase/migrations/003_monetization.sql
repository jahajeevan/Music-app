-- ============================================================
-- 003_monetization.sql
-- Subscriptions, royalty ledger, fan clubs, analytics events
-- ============================================================

-- ─── Subscriptions ────────────────────────────────────────────
create type payment_provider as enum ('stripe', 'apple', 'google', 'manual');
create type subscription_status as enum ('trialing', 'active', 'past_due', 'canceled', 'expired');

create table subscriptions (
  id                   uuid primary key default uuid_generate_v4(),
  user_id              uuid not null references user_profiles(id) on delete cascade,
  tier                 subscription_tier not null,
  status               subscription_status not null default 'trialing',
  provider             payment_provider not null,
  provider_sub_id      text,               -- Stripe subscription ID / Apple original tx ID
  provider_customer_id text,               -- Stripe customer ID
  price_usd_cents      int not null,
  currency             char(3) default 'USD',
  billing_interval     text not null default 'month',  -- 'month' | 'year'
  trial_ends_at        timestamptz,
  current_period_start timestamptz,
  current_period_end   timestamptz,
  canceled_at          timestamptz,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

create index on subscriptions(user_id, status);
create index on subscriptions(provider_sub_id);
create index on subscriptions(current_period_end);

alter table subscriptions enable row level security;

create policy "users see own subscriptions"
  on subscriptions for select
  using (auth.uid() = user_id);

create trigger subscriptions_updated_at
  before update on subscriptions
  for each row execute function set_updated_at();

-- ─── Payment Events (raw webhook log) ────────────────────────
create table payment_events (
  id           uuid primary key default uuid_generate_v4(),
  provider     payment_provider not null,
  event_type   text not null,
  payload      jsonb not null,
  processed    boolean default false,
  error        text,
  received_at  timestamptz not null default now()
);

create index on payment_events(processed, received_at);

-- ─── Royalty Ledger ───────────────────────────────────────────
create table royalty_ledger (
  id              uuid primary key default uuid_generate_v4(),
  track_id        uuid not null references tracks(id),
  artist_id       uuid not null references artists(id),
  period_start    date not null,
  period_end      date not null,
  stream_count    bigint default 0,
  stream_ms       bigint default 0,
  gross_usd_cents bigint default 0,   -- total revenue attributable
  royalty_rate    numeric(6,4),        -- % of gross
  payout_usd_cents bigint default 0,
  is_paid         boolean default false,
  paid_at         timestamptz,
  created_at      timestamptz not null default now()
);

create index on royalty_ledger(artist_id, period_start desc);
create index on royalty_ledger(is_paid, period_end);

-- ─── Fan Club Subscriptions ───────────────────────────────────
create table fan_subscriptions (
  id                   uuid primary key default uuid_generate_v4(),
  fan_user_id          uuid not null references user_profiles(id) on delete cascade,
  artist_id            uuid not null references artists(id) on delete cascade,
  price_usd_cents      int not null,
  status               subscription_status not null default 'active',
  provider             payment_provider not null,
  provider_sub_id      text,
  current_period_end   timestamptz,
  created_at           timestamptz not null default now(),
  unique(fan_user_id, artist_id)
);

create index on fan_subscriptions(artist_id, status);

alter table fan_subscriptions enable row level security;

create policy "fans see own fan subscriptions"
  on fan_subscriptions for select
  using (auth.uid() = fan_user_id);

create policy "artists see their fan subs"
  on fan_subscriptions for select
  using (
    exists (select 1 from artists a where a.id = fan_subscriptions.artist_id and a.owner_user_id = auth.uid())
  );

-- ─── Play Analytics (append-only event log) ──────────────────
-- Note: For production, this table is partitioned by month and
--       mirrored to ClickHouse via Debezium CDC for heavy analytics.
--       Supabase handles the ingestion; ClickHouse handles the queries.
create table play_events (
  id            bigint generated always as identity primary key,
  track_id      uuid not null,
  user_id       uuid,               -- null for anonymous
  session_id    uuid,
  played_at     timestamptz not null default now(),
  play_ms       int,                -- actual listen time before skip/stop
  completed     boolean,
  quality       audio_quality,
  context_type  text,
  context_id    uuid,
  country_code  char(2),
  platform      text,               -- 'ios' | 'android' | 'web'
  app_version   text
) partition by range (played_at);

-- Create monthly partitions for current + next 3 months
create table play_events_2026_06 partition of play_events
  for values from ('2026-06-01') to ('2026-07-01');

create table play_events_2026_07 partition of play_events
  for values from ('2026-07-01') to ('2026-08-01');

create table play_events_2026_08 partition of play_events
  for values from ('2026-08-01') to ('2026-09-01');

create table play_events_2026_09 partition of play_events
  for values from ('2026-09-01') to ('2026-10-01');

create index on play_events(track_id, played_at desc);
create index on play_events(user_id, played_at desc);

-- ─── Promo Codes ──────────────────────────────────────────────
create table promo_codes (
  id                uuid primary key default uuid_generate_v4(),
  code              text not null unique,
  discount_pct      int,            -- e.g., 50 = 50% off
  discount_cents    int,            -- fixed discount
  tier_override     subscription_tier,
  trial_days        int,
  max_uses          int,
  used_count        int default 0,
  expires_at        timestamptz,
  is_active         boolean default true,
  created_at        timestamptz not null default now()
);

create table promo_redemptions (
  id          uuid primary key default uuid_generate_v4(),
  promo_id    uuid not null references promo_codes(id),
  user_id     uuid not null references user_profiles(id),
  sub_id      uuid references subscriptions(id),
  redeemed_at timestamptz not null default now(),
  unique(promo_id, user_id)
);

-- ─── Seed: pricing table ─────────────────────────────────────
create table pricing_plans (
  id              uuid primary key default uuid_generate_v4(),
  tier            subscription_tier not null,
  name            text not null,
  price_usd_cents int not null,
  billing_interval text not null default 'month',
  stripe_price_id text,
  apple_product_id text,
  google_sku      text,
  is_active       boolean default true,
  sort_order      int default 0
);

insert into pricing_plans (tier, name, price_usd_cents, billing_interval, sort_order) values
  ('free',        'Free',       0,     'month', 0),
  ('premium',     'Premium',    999,   'month', 1),
  ('premium',     'Premium',    9999,  'year',  2),
  ('premium_plus','Premium+',   1499,  'month', 3),
  ('premium_plus','Premium+',   14999, 'year',  4),
  ('student',     'Student',    499,   'month', 5),
  ('family',      'Family',     1599,  'month', 6),
  ('artist',      'Artist',     1999,  'month', 7);

-- ─── Function: check if user has active subscription ─────────
create or replace function user_has_tier(user_uuid uuid, required_tier subscription_tier)
returns boolean
language plpgsql security definer
stable
as $$
declare
  v_tier subscription_tier;
begin
  select subscription into v_tier
  from user_profiles
  where id = user_uuid;

  -- tier hierarchy: free < premium < premium_plus
  return case
    when required_tier = 'free' then true
    when required_tier = 'premium' then v_tier in ('premium', 'premium_plus', 'family', 'student')
    when required_tier = 'premium_plus' then v_tier = 'premium_plus'
    else false
  end;
end;
$$;

-- ─── Function: record a stream (called by Edge Function) ─────
create or replace function record_stream(
  p_track_id    uuid,
  p_user_id     uuid,
  p_play_ms     int,
  p_completed   boolean,
  p_quality     audio_quality,
  p_country     char(2),
  p_platform    text
)
returns void
language plpgsql security definer
as $$
begin
  insert into play_events (track_id, user_id, play_ms, completed, quality, country_code, platform)
  values (p_track_id, p_user_id, p_play_ms, p_completed, p_quality, p_country, p_platform);

  -- Increment play count on track (lightweight counter; heavy analytics via ClickHouse)
  update tracks set play_count = play_count + 1 where id = p_track_id;

  -- Update user total play time
  if p_user_id is not null then
    update user_profiles set total_play_ms = total_play_ms + p_play_ms where id = p_user_id;
  end if;
end;
$$;
