-- ============================================================
-- 001_initial_schema.sql
-- Core tables: users, music catalog, library, playback history
-- ============================================================

-- ─── Extensions ───────────────────────────────────────────────
create extension if not exists "uuid-ossp";
create extension if not exists "pg_trgm";      -- fuzzy text search
create extension if not exists "unaccent";     -- accent-insensitive search

-- ─── Enums ────────────────────────────────────────────────────
create type subscription_tier as enum (
  'free', 'premium', 'premium_plus', 'family', 'student', 'artist'
);

create type audio_quality as enum (
  'normal', 'high', 'very_high', 'lossless', 'hi_res_lossless', 'spatial'
);

create type album_type as enum ('album', 'single', 'ep', 'compilation');

create type repeat_mode as enum ('off', 'one', 'all');

-- ─── Users & Profiles ─────────────────────────────────────────
create table user_profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  display_name    text,
  username        text unique,
  avatar_url      text,
  bio             text,
  country_code    char(2) default 'US',
  language_code   char(2) default 'en',
  subscription    subscription_tier not null default 'free',
  subscription_expires_at timestamptz,
  is_public       boolean not null default true,
  total_play_ms   bigint not null default 0,
  followers_count int not null default 0,
  following_count int not null default 0,
  onboarding_done boolean not null default false,
  preferred_genres text[] default '{}',
  preferred_quality audio_quality not null default 'high',
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

alter table user_profiles enable row level security;

create policy "users can read public profiles"
  on user_profiles for select
  using (is_public = true or auth.uid() = id);

create policy "users can update own profile"
  on user_profiles for update
  using (auth.uid() = id);

create policy "users can insert own profile"
  on user_profiles for insert
  with check (auth.uid() = id);

-- ─── Artists ──────────────────────────────────────────────────
create table artists (
  id                uuid primary key default uuid_generate_v4(),
  name              text not null,
  slug              text unique,
  image_url         text,
  header_image_url  text,
  bio               text,
  monthly_listeners bigint default 0,
  total_followers   bigint default 0,
  genres            text[] default '{}',
  country_code      char(2),
  website_url       text,
  instagram_url     text,
  twitter_url       text,
  tiktok_url        text,
  is_verified       boolean default false,
  is_claimed        boolean default false,
  owner_user_id     uuid references user_profiles(id),
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index on artists using gin(to_tsvector('english', name));
create index on artists using gin(genres);

-- ─── Albums ───────────────────────────────────────────────────
create table albums (
  id            uuid primary key default uuid_generate_v4(),
  title         text not null,
  artist_id     uuid not null references artists(id) on delete cascade,
  cover_url     text,
  release_date  date,
  type          album_type not null default 'album',
  total_tracks  int default 0,
  label         text,
  upc           text unique,
  genres        text[] default '{}',
  country_codes text[] default '{}',
  is_explicit   boolean default false,
  play_count    bigint default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index on albums(artist_id);
create index on albums(release_date desc);
create index on albums using gin(to_tsvector('english', title));

-- ─── Tracks ───────────────────────────────────────────────────
create table tracks (
  id               uuid primary key default uuid_generate_v4(),
  title            text not null,
  artist_id        uuid not null references artists(id) on delete cascade,
  album_id         uuid references albums(id) on delete set null,
  duration_ms      int not null,
  track_number     int,
  disc_number      int default 1,
  isrc             text unique,
  genres           text[] default '{}',
  bpm              numeric(5,2),
  key_signature    text,
  energy           numeric(3,2),      -- 0.0 – 1.0
  danceability     numeric(3,2),
  valence          numeric(3,2),      -- musical positivity
  acousticness     numeric(3,2),
  instrumentalness numeric(3,2),
  liveness         numeric(3,2),
  speechiness      numeric(3,2),
  loudness         numeric(5,2),      -- dB
  time_signature   int,
  is_explicit      boolean default false,
  has_lyrics       boolean default false,
  has_lossless     boolean default false,
  has_spatial      boolean default false,
  available_markets text[] default '{}',
  preview_url      text,
  cdn_path         text,              -- relative path on R2
  cdn_path_lossless text,
  cdn_path_hires   text,
  cdn_path_spatial text,
  play_count       bigint default 0,
  skip_count       bigint default 0,
  like_count       bigint default 0,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

create index on tracks(artist_id);
create index on tracks(album_id);
create index on tracks(play_count desc);
create index on tracks using gin(to_tsvector('english', title));
create index on tracks using gin(genres);

-- ─── Lyrics ───────────────────────────────────────────────────
create table lyrics (
  id         uuid primary key default uuid_generate_v4(),
  track_id   uuid not null unique references tracks(id) on delete cascade,
  language   char(2) not null default 'en',
  is_synced  boolean default false,
  lines      jsonb not null default '[]',
  -- each line: {text, start_ms, end_ms, translation?}
  created_at timestamptz not null default now()
);

-- ─── Playlists ────────────────────────────────────────────────
create table playlists (
  id               uuid primary key default uuid_generate_v4(),
  owner_id         uuid not null references user_profiles(id) on delete cascade,
  title            text not null,
  description      text,
  cover_url        text,
  is_public        boolean default true,
  is_collaborative boolean default false,
  is_smart         boolean default false,
  smart_rules      jsonb,             -- rules for auto-updating playlist
  follower_count   int default 0,
  total_tracks     int default 0,
  total_duration_ms bigint default 0,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

create index on playlists(owner_id);
alter table playlists enable row level security;

create policy "anyone can read public playlists"
  on playlists for select
  using (is_public = true or auth.uid() = owner_id);

create policy "owner can modify playlist"
  on playlists for all
  using (auth.uid() = owner_id);

-- ─── Playlist Tracks ──────────────────────────────────────────
create table playlist_tracks (
  id          uuid primary key default uuid_generate_v4(),
  playlist_id uuid not null references playlists(id) on delete cascade,
  track_id    uuid not null references tracks(id) on delete cascade,
  added_by    uuid references user_profiles(id),
  position    int not null,
  added_at    timestamptz not null default now(),
  unique(playlist_id, track_id)
);

create index on playlist_tracks(playlist_id, position);

-- ─── User Library ─────────────────────────────────────────────
create table user_library (
  id           uuid primary key default uuid_generate_v4(),
  user_id      uuid not null references user_profiles(id) on delete cascade,
  track_id     uuid references tracks(id) on delete cascade,
  album_id     uuid references albums(id) on delete cascade,
  playlist_id  uuid references playlists(id) on delete cascade,
  artist_id    uuid references artists(id) on delete cascade,
  saved_at     timestamptz not null default now(),
  check (
    (track_id is not null)::int +
    (album_id is not null)::int +
    (playlist_id is not null)::int +
    (artist_id is not null)::int = 1
  )
);

create index on user_library(user_id, track_id);
create index on user_library(user_id, album_id);
create index on user_library(user_id, playlist_id);
create index on user_library(user_id, artist_id);

alter table user_library enable row level security;

create policy "users manage own library"
  on user_library for all
  using (auth.uid() = user_id);

-- ─── Play History ─────────────────────────────────────────────
create table play_history (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references user_profiles(id) on delete cascade,
  track_id      uuid not null references tracks(id) on delete cascade,
  played_at     timestamptz not null default now(),
  play_duration_ms int,              -- how long they actually listened
  completed     boolean default false,
  quality       audio_quality,
  context_type  text,               -- 'playlist', 'album', 'artist', 'radio', etc.
  context_id    uuid
);

create index on play_history(user_id, played_at desc);
create index on play_history(track_id, played_at desc);

alter table play_history enable row level security;

create policy "users see own history"
  on play_history for all
  using (auth.uid() = user_id);

-- ─── Downloads ────────────────────────────────────────────────
create table downloads (
  id              uuid primary key default uuid_generate_v4(),
  user_id         uuid not null references user_profiles(id) on delete cascade,
  track_id        uuid not null references tracks(id) on delete cascade,
  quality         audio_quality not null,
  file_size_bytes bigint,
  downloaded_at   timestamptz not null default now(),
  expires_at      timestamptz,       -- for DRM: re-verify premium status
  unique(user_id, track_id)
);

alter table downloads enable row level security;

create policy "users manage own downloads"
  on downloads for all
  using (auth.uid() = user_id);

-- ─── Charts ───────────────────────────────────────────────────
create table charts (
  id           uuid primary key default uuid_generate_v4(),
  name         text not null,
  slug         text not null unique,
  country_code char(2),             -- null = global
  genre        text,
  chart_date   date not null,
  created_at   timestamptz not null default now()
);

create table chart_entries (
  id          uuid primary key default uuid_generate_v4(),
  chart_id    uuid not null references charts(id) on delete cascade,
  track_id    uuid not null references tracks(id) on delete cascade,
  position    int not null,
  prev_position int,
  weeks_on    int default 1,
  peak        int,
  unique(chart_id, position)
);

create index on chart_entries(chart_id, position);

-- ─── Updated-at trigger ───────────────────────────────────────
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger user_profiles_updated_at
  before update on user_profiles
  for each row execute function set_updated_at();

create trigger artists_updated_at
  before update on artists
  for each row execute function set_updated_at();

create trigger albums_updated_at
  before update on albums
  for each row execute function set_updated_at();

create trigger tracks_updated_at
  before update on tracks
  for each row execute function set_updated_at();

create trigger playlists_updated_at
  before update on playlists
  for each row execute function set_updated_at();
