import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/color_tokens.dart';

class PodcastPage extends ConsumerStatefulWidget {
  const PodcastPage({super.key, required this.podcastId});

  final String podcastId;

  @override
  ConsumerState<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends ConsumerState<PodcastPage> {
  double _playbackSpeed = 1.0;
  bool _isSubscribed = false;

  final _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0];

  final _episodes = [
    (
      title: 'The Future of Spatial Audio',
      description: 'We dive deep into how Dolby Atmos is changing the way we experience music.',
      durationMs: 3240000,
      publishedAt: '2 days ago',
      isPlayed: false,
      progressMs: 0,
    ),
    (
      title: 'AI in the Music Industry',
      description: 'From AI-generated songs to recommendation engines — what does this mean for artists?',
      durationMs: 4800000,
      publishedAt: '1 week ago',
      isPlayed: true,
      progressMs: 4800000,
    ),
    (
      title: 'The Vinyl Revival with Jack White',
      description: 'A conversation about analog sound and why records are making a comeback.',
      durationMs: 5400000,
      publishedAt: '2 weeks ago',
      isPlayed: false,
      progressMs: 1200000,
    ),
    (
      title: 'Breaking Into Afrobeats',
      description: 'How West African sounds conquered global charts and what's next.',
      durationMs: 3900000,
      publishedAt: '3 weeks ago',
      isPlayed: true,
      progressMs: 3900000,
    ),
    (
      title: 'Streaming Economics 101',
      description: 'The math behind royalties and why artists earn so little per stream.',
      durationMs: 4200000,
      publishedAt: '1 month ago',
      isPlayed: false,
      progressMs: 0,
    ),
  ];

  String _formatDuration(int ms) {
    final minutes = (ms / 60000).floor();
    if (minutes < 60) return '${minutes}m';
    final hours = (minutes / 60).floor();
    final rem = minutes % 60;
    return '${hours}h ${rem}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaveColors.bg,
      body: CustomScrollView(
        slivers: [
          // App bar with podcast art
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: WaveColors.bg,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/seed/pod${widget.podcastId}/600/600',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          WaveColors.bg.withOpacity(0.9),
                          WaveColors.bg,
                        ],
                        stops: const [0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sound Waves Podcast',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'By Wavelength Studios · Music & Culture',
                    style: TextStyle(color: WaveColors.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.people_rounded,
                          color: WaveColors.textMuted, size: 14),
                      const SizedBox(width: 4),
                      const Text('482K followers',
                          style: TextStyle(
                              color: WaveColors.textMuted, fontSize: 12)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Subscribe + Follow row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              setState(() => _isSubscribed = !_isSubscribed),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSubscribed
                                ? WaveColors.surfaceCard
                                : WaveColors.primary,
                          ),
                          child: Text(
                            _isSubscribed ? 'Subscribed ✓' : 'Subscribe',
                            style: TextStyle(
                              color: _isSubscribed
                                  ? WaveColors.textMuted
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: WaveColors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.share_rounded,
                              color: WaveColors.textSecondary),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: WaveColors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz_rounded,
                              color: WaveColors.textSecondary),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // About
                  const Text(
                    'About',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Deep dives into music culture, technology, and the business behind your favorite sounds. New episodes every Tuesday.',
                    style: TextStyle(
                        color: WaveColors.textSecondary, fontSize: 13, height: 1.5),
                  ),

                  const SizedBox(height: 20),

                  // Speed selector
                  Row(
                    children: [
                      const Text(
                        'Playback speed',
                        style: TextStyle(
                            color: WaveColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          final idx = _speeds.indexOf(_playbackSpeed);
                          setState(() {
                            _playbackSpeed =
                                _speeds[(idx + 1) % _speeds.length];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: WaveColors.surfaceCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: WaveColors.primary, width: 1),
                          ),
                          child: Text(
                            '${_playbackSpeed}x',
                            style: const TextStyle(
                              color: WaveColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Episodes header
                  const Text(
                    'All Episodes',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Episode list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final ep = _episodes[i];
                final progress = ep.progressMs > 0 && !ep.isPlayed
                    ? ep.progressMs / ep.durationMs
                    : 0.0;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: WaveColors.surfaceCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              ep.publishedAt,
                              style: const TextStyle(
                                  color: WaveColors.textMuted, fontSize: 11),
                            ),
                            const SizedBox(width: 8),
                            if (ep.isPlayed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: WaveColors.surfaceOverlay,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PLAYED',
                                  style: TextStyle(
                                      color: WaveColors.textMuted,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ep.title,
                          style: TextStyle(
                            color: ep.isPlayed
                                ? WaveColors.textMuted
                                : WaveColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ep.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: WaveColors.textMuted, fontSize: 12, height: 1.4),
                        ),

                        // Progress bar if partially listened
                        if (progress > 0) ...[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: WaveColors.surfaceOverlay,
                              valueColor: const AlwaysStoppedAnimation(WaveColors.primary),
                              minHeight: 3,
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              _formatDuration(ep.durationMs),
                              style: const TextStyle(
                                  color: WaveColors.textMuted, fontSize: 12),
                            ),
                            const Spacer(),
                            // Download button
                            IconButton(
                              icon: const Icon(Icons.download_rounded,
                                  color: WaveColors.textMuted, size: 20),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 16),
                            // Queue button
                            IconButton(
                              icon: const Icon(Icons.playlist_add_rounded,
                                  color: WaveColors.textMuted, size: 20),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 16),
                            // Play button
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: WaveColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow_rounded,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _episodes.length,
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}
