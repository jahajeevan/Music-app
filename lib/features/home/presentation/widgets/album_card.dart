import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/color_tokens.dart';
import '../../../../shared/models/album.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album, this.onTap});

  final Album album;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: album.coverUrl != null
                  ? CachedNetworkImage(
                      imageUrl: album.coverUrl!,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 130,
                        height: 130,
                        color: WaveColors.surfaceCard,
                        child: const Icon(Icons.album_rounded,
                            color: WaveColors.textMuted, size: 40),
                      ),
                    )
                  : Container(
                      width: 130,
                      height: 130,
                      color: WaveColors.surfaceCard,
                      child: const Icon(Icons.album_rounded,
                          color: WaveColors.textMuted, size: 40),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              album.title,
              style: const TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              album.artistName,
              style: const TextStyle(
                color: WaveColors.textMuted,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
