import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/models/album.dart';
import '../../../../shared/models/playlist.dart';
import '../../../../shared/models/artist.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final likedTracksProvider = FutureProvider.autoDispose<List<Track>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final service = ref.watch(supabaseServiceProvider);
  final data = await service.getLikedTracks(user.id);

  return data.map((item) {
    final trackData = item['tracks'] as Map<String, dynamic>? ?? item;
    final artistData = trackData['artists'] as Map<String, dynamic>? ?? {};
    final albumData = trackData['albums'] as Map<String, dynamic>? ?? {};

    final artist = Artist(
      id: artistData['id'] as String? ?? '',
      name: artistData['name'] as String? ?? 'Unknown Artist',
    );
    final album = Album(
      id: albumData['id'] as String? ?? '',
      title: albumData['title'] as String? ?? 'Unknown Album',
      artistId: artist.id,
      artistName: artist.name,
      coverUrl: albumData['cover_url'] as String?,
    );

    return Track(
      id: trackData['id'] as String? ?? '',
      title: trackData['title'] as String? ?? 'Unknown',
      artist: artist,
      album: album,
      durationMs: trackData['duration_ms'] as int? ?? 0,
      isLiked: true,
    );
  }).toList();
});

final savedAlbumsProvider = FutureProvider.autoDispose<List<Album>>((ref) async {
  // TODO: fetch from Supabase
  return [];
});

final userPlaylistsProvider = FutureProvider.autoDispose<List<Playlist>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final service = ref.watch(supabaseServiceProvider);
  final data = await service.getUserPlaylists(user.id);

  return data.map((item) => Playlist(
    id: item['id'] as String,
    title: item['title'] as String,
    ownerId: item['owner_id'] as String,
    description: item['description'] as String?,
    coverUrl: item['cover_url'] as String?,
    isPublic: item['public'] as bool? ?? false,
    trackCount: item['track_count'] as int? ?? 0,
  )).toList();
});

// Like/unlike track notifier
final likeControllerProvider = Provider((ref) => LikeController(ref));

class LikeController {
  LikeController(this._ref);
  final Ref _ref;

  Future<void> toggleLike(String trackId, bool currentlyLiked) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    final service = _ref.read(supabaseServiceProvider);
    if (currentlyLiked) {
      await service.unlikeTrack(user.id, trackId);
    } else {
      await service.likeTrack(user.id, trackId);
    }
    _ref.invalidate(likedTracksProvider);
  }
}
