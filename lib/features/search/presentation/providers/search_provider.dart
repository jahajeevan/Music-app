import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/models/album.dart';
import '../../../../shared/models/artist.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../../../core/constants/app_constants.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider.autoDispose<SearchResults>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) return SearchResults.empty();

  // Debounce
  await Future.delayed(
      const Duration(milliseconds: AppConstants.searchDebounceMs));

  if (ref.state.isLoading == false) return SearchResults.empty();

  final service = ref.watch(supabaseServiceProvider);
  final trackData = await service.searchTracks(query);

  final tracks = trackData.map((data) {
    final artistData = data['artists'] as Map<String, dynamic>? ?? {};
    final albumData = data['albums'] as Map<String, dynamic>? ?? {};

    final artist = Artist(
      id: artistData['id'] as String? ?? '',
      name: artistData['name'] as String? ?? '',
      imageUrl: artistData['image_url'] as String?,
    );

    final album = Album(
      id: albumData['id'] as String? ?? '',
      title: albumData['title'] as String? ?? '',
      artistId: artist.id,
      artistName: artist.name,
      coverUrl: albumData['cover_url'] as String?,
    );

    return Track(
      id: data['id'] as String,
      title: data['title'] as String,
      artist: artist,
      album: album,
      durationMs: data['duration_ms'] as int? ?? 0,
      isExplicit: data['explicit'] as bool? ?? false,
      hasLossless: data['has_lossless'] as bool? ?? false,
    );
  }).toList();

  return SearchResults(tracks: tracks, albums: [], artists: []);
});

class SearchResults {
  const SearchResults({
    required this.tracks,
    required this.albums,
    required this.artists,
  });

  final List<Track> tracks;
  final List<Album> albums;
  final List<Artist> artists;

  bool get isEmpty => tracks.isEmpty && albums.isEmpty && artists.isEmpty;

  static SearchResults empty() =>
      const SearchResults(tracks: [], albums: [], artists: []);
}
