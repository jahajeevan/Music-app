import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app/theme/color_tokens.dart';
import '../../features/player/presentation/providers/player_provider.dart';
import '../models/track.dart';

class TrackTile extends ConsumerWidget {
  const TrackTile({
    super.key,
    required this.track,
    this.showNumber,
    this.onTap,
    this.trailing,
    this.contextTracks,
    this.contextId,
    this.contextType = 'list',
  });

  final Track track;
  final int? showNumber;
  final VoidCallback? onTap;
  final Widget? trailing;
  final List<Track>? contextTracks;
  final String? contextId;
  final String contextType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = ref.watch(currentTrackProvider);
    final isPlayingAsync = ref.watch(isPlayingProvider);
    final isCurrentTrack = currentTrack?.id == track.id;
    final isPlaying = isCurrentTrack && (isPlayingAsync.valueOrNull ?? false);
    final controller = ref.read(playerControllerProvider);

    return InkWell(
      onTap: onTap ??
          () {
            if (contextTracks != null) {
              final idx = contextTracks!.indexWhere((t) => t.id == track.id);
              controller.playQueue(
                contextTracks!,
                startIndex: idx >= 0 ? idx : 0,
                contextType: contextType,
                contextId: contextId,
              );
            } else {
              controller.playTrack(track, contextType: contextType);
            }
          },
      onLongPress: () => _showContextMenu(context, ref),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Number or art
            if (showNumber != null)
              SizedBox(
                width: 28,
                child: Text(
                  '$showNumber',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isCurrentTrack
                        ? WaveColors.primary
                        : WaveColors.textMuted,
                    fontSize: 14,
                    fontWeight: isCurrentTrack
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    track.coverUrl != null
                        ? CachedNetworkImage(
                            imageUrl: track.coverUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _PlaceholderArt(),
                          )
                        : _PlaceholderArt(),
                    if (isCurrentTrack)
                      Container(
                        width: 48,
                        height: 48,
                        color: Colors.black54,
                        child: Icon(
                          isPlaying
                              ? Icons.equalizer_rounded
                              : Icons.play_arrow_rounded,
                          color: WaveColors.primary,
                          size: 22,
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: TextStyle(
                      color: isCurrentTrack
                          ? WaveColors.primary
                          : WaveColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (track.isExplicit)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: WaveColors.textMuted.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'E',
                            style: TextStyle(
                                color: WaveColors.textMuted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          '${track.artistName} · ${track.albumTitle}',
                          style: const TextStyle(
                            color: WaveColors.textMuted,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (track.hasLossless)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: _QualityBadge(
                              label: 'LOSSLESS',
                              color: WaveColors.qualityLossless),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Trailing or duration
            trailing ??
                Text(
                  track.formattedDuration,
                  style: const TextStyle(
                      color: WaveColors.textMuted, fontSize: 12),
                ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded,
                  color: WaveColors.textMuted, size: 20),
              onPressed: () => _showContextMenu(context, ref),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: WaveColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Track header
            Row(
              children: [
                if (track.coverUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: track.coverUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(track.title,
                          style: const TextStyle(
                              color: WaveColors.textPrimary,
                              fontWeight: FontWeight.w700)),
                      Text(track.artistName,
                          style: const TextStyle(
                              color: WaveColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: WaveColors.surfaceOverlay),
            ListTile(
              leading: const Icon(Icons.playlist_play_rounded,
                  color: WaveColors.textSecondary),
              title: const Text('Play next',
                  style: TextStyle(color: WaveColors.textPrimary)),
              onTap: () => Navigator.pop(context),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add_rounded,
                  color: WaveColors.textSecondary),
              title: const Text('Add to playlist',
                  style: TextStyle(color: WaveColors.textPrimary)),
              onTap: () => Navigator.pop(context),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded,
                  color: WaveColors.textSecondary),
              title: const Text('View artist',
                  style: TextStyle(color: WaveColors.textPrimary)),
              onTap: () => Navigator.pop(context),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.album_rounded,
                  color: WaveColors.textSecondary),
              title: const Text('View album',
                  style: TextStyle(color: WaveColors.textPrimary)),
              onTap: () => Navigator.pop(context),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded,
                  color: WaveColors.textSecondary),
              title: const Text('Share',
                  style: TextStyle(color: WaveColors.textPrimary)),
              onTap: () => Navigator.pop(context),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.download_rounded,
                  color: WaveColors.textSecondary),
              title: const Text('Download',
                  style: TextStyle(color: WaveColors.textPrimary)),
              onTap: () => Navigator.pop(context),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderArt extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        color: WaveColors.surfaceOverlay,
        child: const Icon(Icons.music_note_rounded,
            color: WaveColors.textMuted, size: 22),
      );
}

class _QualityBadge extends StatelessWidget {
  const _QualityBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5),
        ),
      );
}
