import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/color_tokens.dart';
import '../../../../shared/models/artist.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/models/album.dart';
import '../../../../shared/widgets/track_tile.dart';
import '../../../home/presentation/widgets/album_card.dart';

class ArtistPage extends ConsumerWidget {
  const ArtistPage({super.key, required this.artistId});

  final String artistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock artist data
    final artist = Artist(
      id: artistId,
      name: 'The Weeknd',
      imageUrl: 'https://picsum.photos/seed/artist_$artistId/600/600',
      bio: 'Abel Makkonen Tesfaye, known professionally as The Weeknd, is a Canadian singer, songwriter, and record producer.',
      monthlyListeners: 85000000,
      genres: ['R&B', 'Pop', 'Synth-pop'],
      isVerified: true,
      isFollowed: false,
    );

    return Scaffold(
      backgroundColor: WaveColors.bg,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: WaveColors.bg,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: artist.imageUrl ?? '',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xCC0A0A0F),
                          WaveColors.bg,
                        ],
                        stops: [0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (artist.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: WaveColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: WaveColors.primary.withOpacity(0.4)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified_rounded,
                                    color: WaveColors.primary, size: 12),
                                SizedBox(width: 4),
                                Text('Verified Artist',
                                    style: TextStyle(
                                        color: WaveColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          artist.name,
                          style: const TextStyle(
                            color: WaveColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          '${_formatListeners(artist.monthlyListeners)} monthly listeners',
                          style: const TextStyle(
                              color: WaveColors.textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Play'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          artist.isFollowed ? 'Following' : 'Follow',
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded,
                            color: WaveColors.textMuted),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Genres
                  Wrap(
                    spacing: 8,
                    children: artist.genres
                        .map((g) => Chip(
                              label: Text(g),
                              backgroundColor:
                                  WaveColors.primary.withOpacity(0.15),
                              labelStyle: const TextStyle(
                                  color: WaveColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                              side: BorderSide(
                                  color: WaveColors.primary.withOpacity(0.3)),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Popular tracks
                  const Text(
                    'Popular',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Top tracks
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final mockTrack = Track(
                  id: 'track_$i',
                  title: ['Blinding Lights', 'Save Your Tears', 'Starboy',
                    'The Hills', 'Can\'t Feel My Face'][i % 5],
                  artist: Artist(id: artistId, name: artist.name),
                  album: Album(
                    id: 'album_$i',
                    title: 'After Hours',
                    artistId: artistId,
                    artistName: artist.name,
                    coverUrl:
                        'https://picsum.photos/seed/aw${i}x/300/300',
                  ),
                  durationMs: 200000 + i * 15000,
                  hasLossless: i < 3,
                  previewUrl: '',
                );
                return TrackTile(
                  track: mockTrack,
                  showNumber: i + 1,
                );
              },
              childCount: 5,
            ),
          ),

          // Albums
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Text(
                    'Discography',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 5,
                    itemBuilder: (_, i) => AlbumCard(
                      album: Album(
                        id: 'disc_$i',
                        title: ['After Hours', 'Starboy', 'Beauty Behind the Madness',
                            'Kiss Land', 'Dawn FM'][i],
                        artistId: artistId,
                        artistName: artist.name,
                        coverUrl:
                            'https://picsum.photos/seed/disc$i/300/300',
                        releaseDate: '202${i}-01-01',
                        totalTracks: 14,
                      ),
                    ),
                  ),
                ),

                // Bio
                if (artist.bio != null) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 28, 20, 10),
                    child: Text(
                      'About',
                      style: TextStyle(
                        color: WaveColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      artist.bio!,
                      style: const TextStyle(
                          color: WaveColors.textSecondary,
                          fontSize: 14,
                          height: 1.6),
                    ),
                  ),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatListeners(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K';
    return '$count';
  }
}
