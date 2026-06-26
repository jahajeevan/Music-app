import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/color_tokens.dart';
import '../providers/player_provider.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(currentTrackProvider);
    if (track == null) return const SizedBox.shrink();

    final isPlayingAsync = ref.watch(isPlayingProvider);
    final positionAsync = ref.watch(playbackPositionProvider);
    final durationAsync = ref.watch(playbackDurationProvider);
    final controller = ref.read(playerControllerProvider);

    final isPlaying = isPlayingAsync.valueOrNull ?? false;
    final position = positionAsync.valueOrNull ?? Duration.zero;
    final duration = durationAsync.valueOrNull ?? const Duration(seconds: 1);
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.fullPlayer),
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < -200) {
          context.push(AppRoutes.fullPlayer);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: WaveColors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar at top
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: WaveColors.surfaceOverlay,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(WaveColors.primary),
                minHeight: 2,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
                child: Row(
                  children: [
                    // Album art
                    Hero(
                      tag: 'album-art-${track.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: track.coverUrl != null
                            ? CachedNetworkImage(
                                imageUrl: track.coverUrl!,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 46,
                                height: 46,
                                color: WaveColors.surfaceOverlay,
                                child: const Icon(Icons.music_note,
                                    color: WaveColors.textMuted),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Track info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: const TextStyle(
                              color: WaveColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            track.artistName,
                            style: const TextStyle(
                              color: WaveColors.textMuted,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Controls
                    IconButton(
                      onPressed: () => controller.skipPrevious(),
                      icon: const Icon(Icons.skip_previous_rounded,
                          color: WaveColors.textSecondary),
                      iconSize: 26,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                          minWidth: 36, minHeight: 36),
                    ),
                    GestureDetector(
                      onTap: () => controller.togglePlayPause(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: WaveColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.skipNext(),
                      icon: const Icon(Icons.skip_next_rounded,
                          color: WaveColors.textSecondary),
                      iconSize: 26,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                          minWidth: 36, minHeight: 36),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
