-- ============================================================
-- 002_social_tables.sql
-- Social graph, listening parties, activity feed, stories
-- ============================================================

-- ─── Follows ──────────────────────────────────────────────────
create table follows (
  follower_id uuid not null references user_profiles(id) on delete cascade,
  followee_id uuid not null references user_profiles(id) on delete cascade,
  followed_at timestamptz not null default now(),
  primary key (follower_id, followee_id),
  check (follower_id <> followee_id)
);

create index on follows(followee_id);
create index on follows(follower_id);

alter table follows enable row level security;

create policy "anyone can read follows"
  on follows for select using (true);

create policy "users manage own follows"
  on follows for all
  using (auth.uid() = follower_id);

-- update follower/following counts via trigger
create or replace function update_follow_counts()
returns trigger language plpgsql security definer as $$
begin
  if tg_op = 'INSERT' then
    update user_profiles set following_count = following_count + 1 where id = new.follower_id;
    update user_profiles set followers_count = followers_count + 1 where id = new.followee_id;
  elsif tg_op = 'DELETE' then
    update user_profiles set following_count = following_count - 1 where id = old.follower_id;
    update user_profiles set followers_count = followers_count - 1 where id = old.followee_id;
  end if;
  return null;
end;
$$;

create trigger follows_count_trigger
  after insert or delete on follows
  for each row execute function update_follow_counts();

-- ─── Artist Follows ───────────────────────────────────────────
create table artist_follows (
  user_id     uuid not null references user_profiles(id) on delete cascade,
  artist_id   uuid not null references artists(id) on delete cascade,
  followed_at timestamptz not null default now(),
  primary key (user_id, artist_id)
);

create index on artist_follows(artist_id);

alter table artist_follows enable row level security;

create policy "users manage own artist follows"
  on artist_follows for all
  using (auth.uid() = user_id);

create policy "anyone can read artist follows"
  on artist_follows for select using (true);

-- ─── Stories (24-hour music moments) ─────────────────────────
create table stories (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references user_profiles(id) on delete cascade,
  track_id      uuid not null references tracks(id) on delete cascade,
  clip_start_ms int default 0,
  clip_end_ms   int,              -- defaults to track end or 30s
  caption       text,
  reaction_emoji text,
  views_count   int default 0,
  expires_at    timestamptz not null default (now() + interval '24 hours'),
  created_at    timestamptz not null default now()
);

create index on stories(user_id, created_at desc);
create index on stories(expires_at);   -- for cleanup job

alter table stories enable row level security;

create policy "followers can view stories"
  on stories for select
  using (
    auth.uid() = user_id
    or exists (
      select 1 from follows
      where follower_id = auth.uid() and followee_id = stories.user_id
    )
  );

create policy "users manage own stories"
  on stories for insert with check (auth.uid() = user_id);

create policy "users delete own stories"
  on stories for delete using (auth.uid() = user_id);

-- ─── Activity Feed ────────────────────────────────────────────
create type feed_item_type as enum (
  'liked_track', 'saved_album', 'followed_artist',
  'created_playlist', 'shared_track', 'story', 'listening_party'
);

create table activity_feed (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references user_profiles(id) on delete cascade,
  type        feed_item_type not null,
  track_id    uuid references tracks(id) on delete cascade,
  album_id    uuid references albums(id) on delete cascade,
  artist_id   uuid references artists(id) on delete cascade,
  playlist_id uuid references playlists(id) on delete cascade,
  story_id    uuid references stories(id) on delete cascade,
  metadata    jsonb default '{}',
  created_at  timestamptz not null default now()
);

create index on activity_feed(user_id, created_at desc);

alter table activity_feed enable row level security;

create policy "followers see feed"
  on activity_feed for select
  using (
    auth.uid() = user_id
    or exists (
      select 1 from follows
      where follower_id = auth.uid() and followee_id = activity_feed.user_id
    )
  );

-- ─── Reactions ────────────────────────────────────────────────
create type reaction_emoji as enum ('fire', 'heart', 'wow', 'dance', 'sad', 'laugh');

create table reactions (
  id              uuid primary key default uuid_generate_v4(),
  user_id         uuid not null references user_profiles(id) on delete cascade,
  feed_item_id    uuid references activity_feed(id) on delete cascade,
  party_chat_id   uuid,             -- refs listening_party_messages.id
  emoji           reaction_emoji not null,
  created_at      timestamptz not null default now(),
  unique(user_id, feed_item_id)
);

alter table reactions enable row level security;

create policy "anyone can see reactions"
  on reactions for select using (true);

create policy "users manage own reactions"
  on reactions for all
  using (auth.uid() = user_id);

-- ─── Listening Parties ────────────────────────────────────────
create type party_status as enum ('waiting', 'live', 'ended');

create table listening_parties (
  id              uuid primary key default uuid_generate_v4(),
  host_id         uuid not null references user_profiles(id) on delete cascade,
  title           text not null,
  description     text,
  cover_url       text,
  status          party_status not null default 'waiting',
  current_track_id uuid references tracks(id),
  playback_position_ms bigint default 0,
  is_public       boolean default true,
  max_members     int default 100,
  member_count    int default 0,
  scheduled_at    timestamptz,
  started_at      timestamptz,
  ended_at        timestamptz,
  created_at      timestamptz not null default now()
);

create index on listening_parties(status, created_at desc);

alter table listening_parties enable row level security;

create policy "anyone can view public parties"
  on listening_parties for select
  using (is_public = true or auth.uid() = host_id);

create policy "hosts manage own parties"
  on listening_parties for all
  using (auth.uid() = host_id);

-- ─── Party Members ────────────────────────────────────────────
create table party_members (
  party_id   uuid not null references listening_parties(id) on delete cascade,
  user_id    uuid not null references user_profiles(id) on delete cascade,
  joined_at  timestamptz not null default now(),
  is_dj      boolean default false,    -- can control queue
  primary key (party_id, user_id)
);

create index on party_members(party_id);

alter table party_members enable row level security;

create policy "members see party members"
  on party_members for select
  using (
    exists (select 1 from party_members pm where pm.party_id = party_members.party_id and pm.user_id = auth.uid())
    or exists (select 1 from listening_parties lp where lp.id = party_members.party_id and lp.is_public)
  );

create policy "users manage own membership"
  on party_members for all
  using (auth.uid() = user_id);

-- ─── Party Queue ──────────────────────────────────────────────
create table party_queue (
  id          uuid primary key default uuid_generate_v4(),
  party_id    uuid not null references listening_parties(id) on delete cascade,
  track_id    uuid not null references tracks(id) on delete cascade,
  added_by    uuid not null references user_profiles(id),
  position    int not null,
  played_at   timestamptz,
  unique(party_id, position)
);

create index on party_queue(party_id, position);

-- ─── Party Chat ───────────────────────────────────────────────
create table party_messages (
  id          uuid primary key default uuid_generate_v4(),
  party_id    uuid not null references listening_parties(id) on delete cascade,
  user_id     uuid not null references user_profiles(id) on delete cascade,
  content     text,
  emoji       text,              -- quick reaction, no text
  created_at  timestamptz not null default now()
);

create index on party_messages(party_id, created_at desc);

alter table party_messages enable row level security;

create policy "party members can read messages"
  on party_messages for select
  using (
    exists (select 1 from party_members pm where pm.party_id = party_messages.party_id and pm.user_id = auth.uid())
  );

create policy "party members can send messages"
  on party_messages for insert
  with check (
    auth.uid() = user_id and
    exists (select 1 from party_members pm where pm.party_id = party_messages.party_id and pm.user_id = auth.uid())
  );

-- ─── Notifications ────────────────────────────────────────────
create type notification_type as enum (
  'new_follower', 'friend_liked', 'friend_listening_party',
  'new_release', 'comment', 'reaction', 'party_invite', 'system'
);

create table notifications (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references user_profiles(id) on delete cascade,
  type        notification_type not null,
  actor_id    uuid references user_profiles(id) on delete set null,
  payload     jsonb default '{}',
  is_read     boolean default false,
  created_at  timestamptz not null default now()
);

create index on notifications(user_id, is_read, created_at desc);

alter table notifications enable row level security;

create policy "users see own notifications"
  on notifications for all
  using (auth.uid() = user_id);

-- ─── Comments ─────────────────────────────────────────────────
create table comments (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references user_profiles(id) on delete cascade,
  track_id    uuid references tracks(id) on delete cascade,
  feed_item_id uuid references activity_feed(id) on delete cascade,
  parent_id   uuid references comments(id) on delete cascade,  -- reply threading
  content     text not null,
  like_count  int default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index on comments(track_id, created_at desc);
create index on comments(feed_item_id, created_at desc);
create index on comments(parent_id);

alter table comments enable row level security;

create policy "anyone can read comments"
  on comments for select using (true);

create policy "users manage own comments"
  on comments for all
  using (auth.uid() = user_id);

-- ─── Realtime publications ────────────────────────────────────
-- Enable Realtime for live features
alter publication supabase_realtime add table party_messages;
alter publication supabase_realtime add table party_members;
alter publication supabase_realtime add table listening_parties;
alter publication supabase_realtime add table notifications;
