import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_tokens.dart';
import '../../../home/presentation/widgets/section_header.dart';
import '../../../home/presentation/widgets/album_card.dart';
import '../../../home/presentation/widgets/album_card.dart';
import '../../../../shared/models/album.dart';

class DiscoveryPage extends ConsumerWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: WaveColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: WaveColors.bg,
            title: const Text(
              'Discover',
              style: TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded,
                    color: WaveColors.textPrimary),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Charts section
                const SizedBox(height: 8),
                SectionHeader(title: 'Global Charts', onSeeAll: () {}),
                const SizedBox(height: 12),
                _GlobalChartsRow(),

                const SizedBox(height: 28),

                // Trending by region
                SectionHeader(
                    title: 'Trending by Region', onSeeAll: () {}),
                const SizedBox(height: 12),
                _RegionRow(),

                const SizedBox(height: 28),

                // New releases this week
                SectionHeader(
                    title: 'New This Friday', onSeeAll: () {}),
                const SizedBox(height: 12),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 6,
                    itemBuilder: (_, i) => AlbumCard(
                      album: Album(
                        id: 'new_$i',
                        title: 'New Drop ${i + 1}',
                        artistId: '1',
                        artistName: 'Artist ${i + 1}',
                        coverUrl:
                            'https://picsum.photos/seed/new$i/300/300',
                        totalTracks: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Viral before they blow up
                _ViralSection(),

                const SizedBox(height: 28),

                // Music Time Machine
                _TimeMachineBanner(),

                const SizedBox(height: 28),

                // Genre deep dives
                SectionHeader(title: 'Genre Deep Dives', onSeeAll: () {}),
                const SizedBox(height: 12),
                _GenreDeepDiveRow(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobalChartsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final charts = [
      (name: 'Global Top 50', tracks: '50 tracks', emoji: '🌍',
        color: WaveColors.primary),
      (name: 'Top 200', tracks: '200 tracks', emoji: '📈',
        color: WaveColors.accent),
      (name: 'Viral 50', tracks: '50 tracks', emoji: '🔥',
        color: WaveColors.accentWarm),
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: charts.length,
        itemBuilder: (_, i) {
          final c = charts[i];
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.color.withOpacity(0.3), c.color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.color.withOpacity(0.25)),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(c.emoji, style: const TextStyle(fontSize: 28)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name,
                              style: TextStyle(
                                color: c.color,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              )),
                          Text(c.tracks,
                              style: const TextStyle(
                                  color: WaveColors.textMuted, fontSize: 11)),
                        ],
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

class _RegionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final regions = [
      (flag: '🇺🇸', name: 'United States'),
      (flag: '🇬🇧', name: 'United Kingdom'),
      (flag: '🇯🇵', name: 'Japan'),
      (flag: '🇰🇷', name: 'South Korea'),
      (flag: '🇧🇷', name: 'Brazil'),
      (flag: '🇮🇳', name: 'India'),
      (flag: '🇳🇬', name: 'Nigeria'),
      (flag: '🇲🇽', name: 'Mexico'),
    ];

    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: regions.length,
        itemBuilder: (_, i) {
          final r = regions[i];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: Material(
              color: WaveColors.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Text(r.flag, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 4),
                      Text(
                        r.name.split(' ').first,
                        style: const TextStyle(
                          color: WaveColors.textMuted,
                          fontSize: 10,
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

class _ViralSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text('🔥 ',
                  style: TextStyle(fontSize: 18)),
              const Text(
                'Going Viral',
                style: TextStyle(
                  color: WaveColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: WaveColors.accentWarm.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: WaveColors.accentWarm.withOpacity(0.3)),
                ),
                child: const Text(
                  'TRENDING',
                  style: TextStyle(
                    color: WaveColors.accentWarm,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Songs blowing up before they break',
            style: TextStyle(color: WaveColors.textMuted, fontSize: 13),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 6,
            itemBuilder: (_, i) => AlbumCard(
              album: Album(
                id: 'viral_$i',
                title: 'Viral Song ${i + 1}',
                artistId: '1',
                artistName: 'New Artist',
                coverUrl: 'https://picsum.photos/seed/vrl$i/300/300',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeMachineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1a1a3e), Color(0xFF0d0d1a)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: WaveColors.primaryLight.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Text('⏳', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Music Time Machine',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'What was #1 on any date in history?',
                    style: TextStyle(
                        color: WaveColors.textMuted, fontSize: 13),
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

class _GenreDeepDiveRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final genres = [
      (name: 'Afrobeats', color: const Color(0xFFFF8C00), emoji: '🌍'),
      (name: 'K-Pop', color: const Color(0xFFFF1493), emoji: '🇰🇷'),
      (name: 'Amapiano', color: const Color(0xFF9B95FF), emoji: '🎵'),
      (name: 'Drill', color: const Color(0xFF808080), emoji: '🎤'),
      (name: 'Synthwave', color: const Color(0xFF6C63FF), emoji: '🌊'),
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        itemBuilder: (_, i) {
          final g = genres[i];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: Material(
              color: g.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                  child: Row(
                    children: [
                      Text(g.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        g.name,
                        style: TextStyle(
                          color: g.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
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
