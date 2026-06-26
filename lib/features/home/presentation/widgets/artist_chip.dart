import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/color_tokens.dart';
import '../../../../shared/models/artist.dart';

class ArtistChip extends StatelessWidget {
  const ArtistChip({super.key, required this.artist, this.onTap});

  final Artist artist;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: WaveColors.surfaceCard,
              backgroundImage: artist.imageUrl != null
                  ? CachedNetworkImageProvider(artist.imageUrl!)
                  : null,
              child: artist.imageUrl == null
                  ? const Icon(Icons.person_rounded,
                      color: WaveColors.textMuted, size: 30)
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              artist.name,
              style: const TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
