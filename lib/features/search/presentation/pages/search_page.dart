import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_tokens.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/models/album.dart';
import '../../../../shared/models/artist.dart';
import '../../../../shared/widgets/track_tile.dart';
import '../../presentation/providers/search_provider.dart';
import '../../presentation/widgets/hum_to_search_widget.dart';
import '../../presentation/widgets/genre_browse_grid.dart';
import '../../../home/presentation/widgets/album_card.dart';
import '../../../home/presentation/widgets/artist_chip.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: WaveColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: const TextStyle(color: WaveColors.textPrimary),
                          textInputAction: TextInputAction.search,
                          onChanged: (v) => ref
                              .read(searchQueryProvider.notifier)
                              .state = v,
                          decoration: InputDecoration(
                            hintText: 'Songs, artists, albums, lyrics...',
                            hintStyle: const TextStyle(
                                color: WaveColors.textMuted, fontSize: 15),
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: WaveColors.textMuted),
                            suffixIcon: query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close_rounded,
                                        color: WaveColors.textMuted),
                                    onPressed: () {
                                      _controller.clear();
                                      ref
                                          .read(searchQueryProvider.notifier)
                                          .state = '';
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Hum to search
                      const HumToSearchButton(),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: query.isEmpty
                  ? const GenreBrowseGrid()
                  : resultsAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (results) => _SearchResults(results: results),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.results});

  final SearchResults results;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded,
                color: WaveColors.textMuted, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No results found',
              style: TextStyle(
                  color: WaveColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching for something else\nor hum the melody',
              textAlign: TextAlign.center,
              style: TextStyle(color: WaveColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        // Top result
        if (results.tracks.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Text(
              'Top Result',
              style: TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _TopResultCard(track: results.tracks.first),
          const SizedBox(height: 24),
        ],

        // Tracks
        if (results.tracks.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              'Songs',
              style: TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ...results.tracks.take(5).map((t) => TrackTile(track: t)),
          const SizedBox(height: 20),
        ],

        // Artists
        if (results.artists.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              'Artists',
              style: TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: results.artists.length,
              itemBuilder: (_, i) => ArtistChip(artist: results.artists[i]),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Albums
        if (results.albums.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              'Albums',
              style: TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: results.albums.length,
              itemBuilder: (_, i) => AlbumCard(album: results.albums[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _TopResultCard extends StatelessWidget {
  const _TopResultCard({required this.track});
  final Track track;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WaveColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (track.coverUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                track.coverUrl!,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: const TextStyle(
                    color: WaveColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${track.artistName} · Song',
                  style: const TextStyle(
                      color: WaveColors.textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.play_circle_filled_rounded,
              color: WaveColors.primary, size: 44),
        ],
      ),
    );
  }
}
