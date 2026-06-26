import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/color_tokens.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/models/album.dart';
import '../../../../shared/models/artist.dart';
import '../../../../shared/widgets/track_tile.dart';
import '../../presentation/widgets/section_header.dart';
import '../../presentation/widgets/album_card.dart';
import '../../presentation/widgets/artist_chip.dart';
import '../../presentation/widgets/mood_selector.dart';
import '../../../player/presentation/providers/player_provider.dart';

// Mock data provider (replace with real Supabase calls)
final homeFeedProvider = FutureProvider.autoDispose((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return _mockHomeFeed();
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(homeFeedProvider);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Scaffold(
      backgroundColor: WaveColors.bg,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: false,
            backgroundColor: WaveColors.bg,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(
                      color: WaveColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    'Wavelength',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: WaveColors.textPrimary),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.settings),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: WaveColors.primary,
                    child: Icon(Icons.person_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),

          feedAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
            data: (feed) => SliverList(
              delegate: SliverChildListDelegate([
                // Mood selector
                const SizedBox(height: 8),
                const MoodSelector(),
                const SizedBox(height: 24),

                // Recently played
                SectionHeader(
                  title: 'Recently Played',
                  onSeeAll: () {},
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: (feed['recentlyPlayed'] as List).length,
                    itemBuilder: (_, i) {
                      final album = (feed['recentlyPlayed'] as List<Album>)[i];
                      return AlbumCard(album: album);
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // Featured banner
                _FeaturedBanner(
                  title: 'Discover Afrobeats',
                  subtitle: '50 tracks · Updated daily',
                  gradient: WaveColors.gradientWarm,
                ),

                const SizedBox(height: 28),

                // Today's top tracks
                SectionHeader(
                  title: 'Top Tracks Today',
                  subtitle: 'Global',
                  onSeeAll: () {},
                ),
                const SizedBox(height: 4),
                ...(feed['topTracks'] as List<Track>)
                    .take(5)
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (e) => TrackTile(
                        track: e.value,
                        showNumber: e.key + 1,
                        contextTracks: feed['topTracks'] as List<Track>,
                        contextType: 'chart',
                      ),
                    ),

                const SizedBox(height: 28),

                // New releases
                SectionHeader(
                  title: 'New Releases',
                  onSeeAll: () {},
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: (feed['newReleases'] as List).length,
                    itemBuilder: (_, i) {
                      final album = (feed['newReleases'] as List<Album>)[i];
                      return AlbumCard(album: album);
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // AI DJ promo
                _AiDjBanner(),

                const SizedBox(height: 28),

                // Featured artists
                SectionHeader(
                  title: 'Trending Artists',
                  onSeeAll: () {},
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: (feed['trendingArtists'] as List).length,
                    itemBuilder: (_, i) {
                      final artist =
                          (feed['trendingArtists'] as List<Artist>)[i];
                      return ArtistChip(artist: artist);
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // Charts section
                SectionHeader(title: 'Charts', onSeeAll: () {}),
                const SizedBox(height: 12),
                _ChartsRow(),

                const SizedBox(height: 100), // bottom padding for mini player
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner({
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 160,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Opacity(
                opacity: 0.15,
                child: Icon(Icons.music_note_rounded,
                    size: 180, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiDjBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.aiDj),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: WaveColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WaveColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: WaveColors.gradientPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.radio_rounded,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI DJ Flux',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your personalized AI radio host. Let Flux take the wheel.',
                    style: TextStyle(
                      color: WaveColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: WaveColors.primary, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ChartsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final charts = [
      (name: 'Global Top 50', icon: Icons.public_rounded, color: WaveColors.primary),
      (name: 'Trending Now', icon: Icons.trending_up_rounded, color: WaveColors.accentWarm),
      (name: 'New This Week', icon: Icons.fiber_new_rounded, color: WaveColors.accent),
      (name: 'Viral Hits', icon: Icons.whatshot_rounded, color: WaveColors.warning),
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: charts.length,
        itemBuilder: (_, i) {
          final chart = charts[i];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: chart.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: chart.color.withOpacity(0.2)),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(chart.icon, color: chart.color, size: 26),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          chart.name,
                          style: TextStyle(
                            color: chart.color,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Mock data ──────────────────────────────────────────────────────────────────

Map<String, dynamic> _mockHomeFeed() {
  final mockArtist = const Artist(
    id: '1',
    name: 'The Weeknd',
    imageUrl: 'https://picsum.photos/seed/artist1/200/200',
  );

  final mockAlbum = Album(
    id: '1',
    title: 'After Hours',
    artistId: '1',
    artistName: 'The Weeknd',
    coverUrl: 'https://picsum.photos/seed/album1/300/300',
    releaseDate: '2020-03-20',
    type: AlbumType.album,
    totalTracks: 14,
  );

  final mockTrack = Track(
    id: '1',
    title: 'Blinding Lights',
    artist: mockArtist,
    album: mockAlbum,
    durationMs: 200000,
    hasLossless: true,
    previewUrl: '',
  );

  final albums = List.generate(
    8,
    (i) => Album(
      id: 'album_$i',
      title: 'Album ${i + 1}',
      artistId: '1',
      artistName: 'Artist ${i + 1}',
      coverUrl: 'https://picsum.photos/seed/alb$i/300/300',
      totalTracks: 10 + i,
    ),
  );

  final tracks = List.generate(
    10,
    (i) => Track(
      id: 'track_$i',
      title: 'Song ${i + 1}',
      artist: const Artist(id: '1', name: 'Various Artists'),
      album: mockAlbum,
      durationMs: 180000 + i * 10000,
      hasLossless: i % 3 == 0,
      previewUrl: '',
    ),
  );

  final artists = List.generate(
    8,
    (i) => Artist(
      id: 'artist_$i',
      name: ['Drake', 'Beyoncé', 'Taylor Swift', 'Bad Bunny', 'BTS',
             'Dua Lipa', 'Burna Boy', 'Billie Eilish'][i % 8],
      imageUrl: 'https://picsum.photos/seed/art$i/200/200',
      monthlyListeners: (i + 1) * 12000000,
    ),
  );

  return {
    'recentlyPlayed': albums.take(6).toList(),
    'topTracks': tracks,
    'newReleases': albums.skip(4).toList(),
    'trendingArtists': artists,
  };
}
