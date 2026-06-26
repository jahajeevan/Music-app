import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/color_tokens.dart';
import '../providers/player_provider.dart';

class FullPlayerPage extends ConsumerStatefulWidget {
  const FullPlayerPage({super.key});

  @override
  ConsumerState<FullPlayerPage> createState() => _FullPlayerPageState();
}

class _FullPlayerPageState extends ConsumerState<FullPlayerPage>
    with TickerProviderStateMixin {
  late AnimationController _albumArtController;
  bool _showLyrics = false;

  @override
  void initState() {
    super.initState();
    _albumArtController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _albumArtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = ref.watch(currentTrackProvider);
    if (track == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.pop());
      return const SizedBox.shrink();
    }

    final isPlayingAsync = ref.watch(isPlayingProvider);
    final positionAsync = ref.watch(playbackPositionProvider);
    final durationAsync = ref.watch(playbackDurationProvider);
    final repeatMode = ref.watch(repeatModeProvider);
    final shuffleEnabled = ref.watch(shuffleEnabledProvider);
    final controller = ref.read(playerControllerProvider);

    final isPlaying = isPlayingAsync.valueOrNull ?? false;
    final position = positionAsync.valueOrNull ?? Duration.zero;
    final duration = durationAsync.valueOrNull ?? const Duration(seconds: 1);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred album art background
          if (track.coverUrl != null)
            CachedNetworkImage(
              imageUrl: track.coverUrl!,
              fit: BoxFit.cover,
            ),
          // Dark overlay + blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: WaveColors.textPrimary, size: 32),
                        onPressed: () => context.pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Now Playing',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: WaveColors.textMuted,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded,
                            color: WaveColors.textPrimary),
                        onPressed: () => _showTrackMenu(context, ref, track),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Album art
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Hero(
                    tag: 'album-art-${track.id}',
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: WaveColors.primary.withOpacity(
                                isPlaying ? 0.35 : 0.15),
                            blurRadius: isPlaying ? 50 : 20,
                            spreadRadius: isPlaying ? 10 : 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: track.coverUrl != null
                            ? CachedNetworkImage(
                                imageUrl: track.coverUrl!,
                                fit: BoxFit.cover,
                              )
                            : AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  color: WaveColors.surfaceCard,
                                  child: const Icon(
                                    Icons.music_note_rounded,
                                    size: 80,
                                    color: WaveColors.textMuted,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Track info + like
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track.title,
                              style: const TextStyle(
                                color: WaveColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              track.artistName,
                              style: const TextStyle(
                                color: WaveColors.textMuted,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          track.isLiked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: track.isLiked
                              ? WaveColors.error
                              : WaveColors.textMuted,
                          size: 28,
                        ),
                        onPressed: () {
                          // Toggle like via provider
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Seek bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 18),
                        ),
                        child: Slider(
                          value: duration.inMilliseconds > 0
                              ? (position.inMilliseconds /
                                      duration.inMilliseconds)
                                  .clamp(0.0, 1.0)
                              : 0.0,
                          onChanged: (v) {
                            final seekPosition = Duration(
                              milliseconds:
                                  (v * duration.inMilliseconds).round(),
                            );
                            controller.seek(seekPosition);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(
                                  color: WaveColors.textMuted, fontSize: 12),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                  color: WaveColors.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Main controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Shuffle
                      IconButton(
                        icon: Icon(
                          Icons.shuffle_rounded,
                          color: shuffleEnabled
                              ? WaveColors.primary
                              : WaveColors.textMuted,
                          size: 26,
                        ),
                        onPressed: controller.toggleShuffle,
                      ),

                      // Previous
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded,
                            color: WaveColors.textPrimary, size: 38),
                        onPressed: controller.skipPrevious,
                        padding: EdgeInsets.zero,
                      ),

                      // Play/pause
                      GestureDetector(
                        onTap: controller.togglePlayPause,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: WaveColors.gradientPrimary,
                            boxShadow: [
                              BoxShadow(
                                color: WaveColors.primary.withOpacity(0.5),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),

                      // Next
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded,
                            color: WaveColors.textPrimary, size: 38),
                        onPressed: controller.skipNext,
                        padding: EdgeInsets.zero,
                      ),

                      // Repeat
                      IconButton(
                        icon: Icon(
                          repeatMode == RepeatMode.one
                              ? Icons.repeat_one_rounded
                              : Icons.repeat_rounded,
                          color: repeatMode != RepeatMode.off
                              ? WaveColors.primary
                              : WaveColors.textMuted,
                          size: 26,
                        ),
                        onPressed: controller.toggleRepeat,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Bottom action row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: Icons.lyrics_rounded,
                        label: 'Lyrics',
                        active: _showLyrics,
                        onTap: () =>
                            setState(() => _showLyrics = !_showLyrics),
                      ),
                      _ActionButton(
                        icon: Icons.mic_rounded,
                        label: 'Karaoke',
                        onTap: () => context.push(
                          AppRoutes.karaoke.replaceFirst(':trackId', track.id),
                        ),
                      ),
                      _ActionButton(
                        icon: Icons.queue_music_rounded,
                        label: 'Queue',
                        onTap: () {},
                      ),
                      _ActionButton(
                        icon: Icons.spatial_audio_rounded,
                        label: 'Spatial',
                        active: track.hasSpatialAudio,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _showTrackMenu(BuildContext context, WidgetRef ref, track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: WaveColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: WaveColors.surfaceOverlay,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _MenuTile(icon: Icons.playlist_add_rounded, label: 'Add to playlist'),
            _MenuTile(icon: Icons.share_rounded, label: 'Share'),
            _MenuTile(icon: Icons.album_rounded, label: 'View album'),
            _MenuTile(icon: Icons.person_rounded, label: 'View artist'),
            _MenuTile(icon: Icons.download_rounded, label: 'Download'),
            _MenuTile(icon: Icons.radio_rounded, label: 'Start radio'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: active ? WaveColors.primary : WaveColors.textMuted,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? WaveColors.primary : WaveColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: WaveColors.textSecondary),
      title: Text(label,
          style: const TextStyle(color: WaveColors.textPrimary, fontSize: 15)),
      onTap: () => Navigator.pop(context),
      contentPadding: EdgeInsets.zero,
    );
  }
}
