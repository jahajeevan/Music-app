-- ============================================================
-- seed.sql — Development seed data
-- Run AFTER all migrations. Uses fixed UUIDs for stable refs.
-- ============================================================

-- ─── Artists ──────────────────────────────────────────────────
insert into artists (id, name, slug, image_url, bio, monthly_listeners, genres, country_code, is_verified) values
  ('a1000000-0000-0000-0000-000000000001', 'The Midnight', 'the-midnight',
   'https://picsum.photos/seed/tm/400/400',
   'Cinematic synthwave duo from Los Angeles. Known for nostalgic 80s-inspired soundscapes.',
   4200000, '{"synthwave","retrowave","indie pop"}', 'US', true),

  ('a1000000-0000-0000-0000-000000000002', 'Aroha', 'aroha',
   'https://picsum.photos/seed/aroha/400/400',
   'Māori R&B artist blending traditional Polynesian melodies with contemporary production.',
   1800000, '{"r&b","soul","pop"}', 'NZ', true),

  ('a1000000-0000-0000-0000-000000000003', 'DJ Kofi', 'dj-kofi',
   'https://picsum.photos/seed/kofi/400/400',
   'Accra-based producer at the forefront of the Afrobeats explosion.',
   3100000, '{"afrobeats","afropop","highlife"}', 'GH', true),

  ('a1000000-0000-0000-0000-000000000004', 'Yuki Tanaka', 'yuki-tanaka',
   'https://picsum.photos/seed/yuki/400/400',
   'Osaka producer crafting delicate ambient electronic music with classical piano roots.',
   920000, '{"ambient","electronic","classical"}', 'JP', false),

  ('a1000000-0000-0000-0000-000000000005', 'Luna García', 'luna-garcia',
   'https://picsum.photos/seed/luna/400/400',
   'Mexican singer-songwriter fusing Latin indie with dream pop aesthetics.',
   2400000, '{"latin indie","dream pop","indie pop"}', 'MX', true)
on conflict (id) do nothing;

-- ─── Albums ───────────────────────────────────────────────────
insert into albums (id, title, artist_id, cover_url, release_date, type, total_tracks, genres) values
  ('b1000000-0000-0000-0000-000000000001', 'Monsters', 'a1000000-0000-0000-0000-000000000001',
   'https://picsum.photos/seed/mon/400/400', '2022-09-09', 'album', 12, '{"synthwave","retrowave"}'),

  ('b1000000-0000-0000-0000-000000000002', 'Te Ao Hou', 'a1000000-0000-0000-0000-000000000002',
   'https://picsum.photos/seed/tao/400/400', '2023-03-17', 'album', 10, '{"r&b","soul"}'),

  ('b1000000-0000-0000-0000-000000000003', 'Lagos Nights', 'a1000000-0000-0000-0000-000000000003',
   'https://picsum.photos/seed/lag/400/400', '2023-07-21', 'album', 14, '{"afrobeats","afropop"}'),

  ('b1000000-0000-0000-0000-000000000004', 'Sakura Protocol', 'a1000000-0000-0000-0000-000000000004',
   'https://picsum.photos/seed/sak/400/400', '2024-01-15', 'album', 8, '{"ambient","electronic"}'),

  ('b1000000-0000-0000-0000-000000000005', 'Mariposa', 'a1000000-0000-0000-0000-000000000005',
   'https://picsum.photos/seed/mar/400/400', '2023-11-03', 'album', 11, '{"latin indie","dream pop"}')
on conflict (id) do nothing;

-- ─── Tracks ───────────────────────────────────────────────────
insert into tracks (id, title, artist_id, album_id, duration_ms, track_number, genres, bpm, energy,
                    danceability, has_lyrics, has_lossless, cdn_path, play_count, like_count) values
  ('c1000000-0000-0000-0000-000000000001', 'Los Angeles', 'a1000000-0000-0000-0000-000000000001',
   'b1000000-0000-0000-0000-000000000001', 248000, 1, '{"synthwave"}', 112.0, 0.72, 0.65, true, true,
   'tracks/the-midnight/monsters/01-los-angeles', 8400000, 312000),

  ('c1000000-0000-0000-0000-000000000002', 'Monsters', 'a1000000-0000-0000-0000-000000000001',
   'b1000000-0000-0000-0000-000000000001', 312000, 2, '{"synthwave"}', 98.0, 0.68, 0.71, true, true,
   'tracks/the-midnight/monsters/02-monsters', 6200000, 285000),

  ('c1000000-0000-0000-0000-000000000003', 'Tūhoe', 'a1000000-0000-0000-0000-000000000002',
   'b1000000-0000-0000-0000-000000000002', 196000, 1, '{"r&b","soul"}', 84.0, 0.55, 0.78, true, false,
   'tracks/aroha/te-ao-hou/01-tuhoe', 2100000, 89000),

  ('c1000000-0000-0000-0000-000000000004', 'Accra Sunset', 'a1000000-0000-0000-0000-000000000003',
   'b1000000-0000-0000-0000-000000000003', 224000, 1, '{"afrobeats"}', 108.0, 0.82, 0.91, true, false,
   'tracks/dj-kofi/lagos-nights/01-accra-sunset', 5700000, 198000),

  ('c1000000-0000-0000-0000-000000000005', 'Cherry Blossom Protocol', 'a1000000-0000-0000-0000-000000000004',
   'b1000000-0000-0000-0000-000000000004', 384000, 1, '{"ambient","electronic"}', 72.0, 0.31, 0.42, false, true,
   'tracks/yuki-tanaka/sakura-protocol/01-cherry-blossom', 1400000, 67000),

  ('c1000000-0000-0000-0000-000000000006', 'Mariposa', 'a1000000-0000-0000-0000-000000000005',
   'b1000000-0000-0000-0000-000000000005', 238000, 1, '{"latin indie","dream pop"}', 92.0, 0.64, 0.74, true, false,
   'tracks/luna-garcia/mariposa/01-mariposa', 3800000, 142000),

  ('c1000000-0000-0000-0000-000000000007', 'Daydream', 'a1000000-0000-0000-0000-000000000001',
   'b1000000-0000-0000-0000-000000000001', 278000, 3, '{"synthwave"}', 104.0, 0.74, 0.69, true, true,
   'tracks/the-midnight/monsters/03-daydream', 4900000, 220000),

  ('c1000000-0000-0000-0000-000000000008', 'Lagos Flex', 'a1000000-0000-0000-0000-000000000003',
   'b1000000-0000-0000-0000-000000000003', 208000, 2, '{"afrobeats","afropop"}', 116.0, 0.88, 0.94, true, false,
   'tracks/dj-kofi/lagos-nights/02-lagos-flex', 7200000, 310000)
on conflict (id) do nothing;

-- ─── Lyrics (synced example) ──────────────────────────────────
insert into lyrics (track_id, language, is_synced, lines) values
  ('c1000000-0000-0000-0000-000000000001', 'en', true, '[
    {"text": "City of angels, city of dreams", "start_ms": 12000, "end_ms": 16800},
    {"text": "Where the neon bleeds into the palm tree leaves", "start_ms": 17000, "end_ms": 22500},
    {"text": "I keep on running but the road loops back", "start_ms": 23000, "end_ms": 28200},
    {"text": "Los Angeles, I''m on the wrong track", "start_ms": 28500, "end_ms": 33000},
    {"text": "But the lights — they pull me in", "start_ms": 44000, "end_ms": 48000},
    {"text": "And the 405 becomes a hymn", "start_ms": 48200, "end_ms": 52800}
  ]')
on conflict (track_id) do nothing;

-- ─── Pricing plans ────────────────────────────────────────────
-- (Already inserted in 003_monetization.sql — skip if conflicts)

-- ─── Global charts ────────────────────────────────────────────
insert into charts (id, name, slug, chart_date) values
  ('d1000000-0000-0000-0000-000000000001', 'Global Top 50', 'global-top-50', current_date),
  ('d1000000-0000-0000-0000-000000000002', 'Global Top 200', 'global-top-200', current_date),
  ('d1000000-0000-0000-0000-000000000003', 'Viral 50', 'viral-50', current_date)
on conflict (slug) do nothing;

insert into chart_entries (chart_id, track_id, position, weeks_on, peak) values
  ('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000008', 1, 3, 1),
  ('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000004', 2, 5, 1),
  ('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000006', 3, 2, 3),
  ('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001', 4, 8, 2),
  ('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000007', 5, 4, 4),
  ('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000002', 6, 6, 3),
  ('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000003', 7, 1, 7)
on conflict (chart_id, position) do nothing;
