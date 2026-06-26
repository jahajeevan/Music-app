import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_tokens.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/models/album.dart';
import '../../../../shared/models/playlist.dart';
import '../../../../shared/widgets/track_tile.dart';
import '../providers/library_provider.dart';
import '../../../home/presentation/widgets/album_card.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaveColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your Library',
                      style: TextStyle(
                        color: WaveColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded,
                        color: WaveColors.textPrimary, size: 28),
                    onPressed: () => _createPlaylist(context, ref),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded,
                        color: WaveColors.textPrimary, size: 26),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: WaveColors.primary,
              unselectedLabelColor: WaveColors.textMuted,
              indicatorColor: WaveColors.primary,
              indicatorWeight: 2,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: const [
                Tab(text: 'Playlists'),
                Tab(text: 'Songs'),
                Tab(text: 'Albums'),
                Tab(text: 'Artists'),
              ],
            ),

            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _PlaylistsTab(),
                  _LikedSongsTab(),
                  _SavedAlbumsTab(),
                  _FollowedArtistsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createPlaylist(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: WaveColors.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: _CreatePlaylistSheet(),
      ),
    );
  }
}

class _PlaylistsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(userPlaylistsProvider);

    return playlists.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (lists) {
        if (lists.isEmpty) {
          return _EmptyState(
            icon: Icons.queue_music_rounded,
            title: 'No playlists yet',
            subtitle: 'Tap + to create your first playlist',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 100),
          itemCount: lists.length,
          itemBuilder: (_, i) => _PlaylistTile(playlist: lists[i]),
        );
      },
    );
  }
}

class _LikedSongsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liked = ref.watch(likedTracksProvider);

    return liked.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (tracks) {
        if (tracks.isEmpty) {
          return _EmptyState(
            icon: Icons.favorite_rounded,
            title: 'No liked songs',
            subtitle: 'Tap the heart on any track to save it here',
          );
        }
        return ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            // Liked songs header
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: WaveColors.gradientPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite_rounded,
                      color: Colors.white, size: 36),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Liked Songs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${tracks.length} songs',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ...tracks.map((t) => TrackTile(track: t, contextTracks: tracks)),
          ],
        );
      },
    );
  }
}

class _SavedAlbumsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(savedAlbumsProvider);

    return albums.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) {
        if (list.isEmpty) {
          return _EmptyState(
            icon: Icons.album_rounded,
            title: 'No saved albums',
            subtitle: 'Save albums to find them here',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: list.length,
          itemBuilder: (_, i) => AlbumCard(album: list[i]),
        );
      },
    );
  }
}

class _FollowedArtistsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _EmptyState(
      icon: Icons.people_rounded,
      title: 'No followed artists',
      subtitle: 'Follow artists to see them here',
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({required this.playlist});
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: playlist.coverUrl != null
            ? Image.network(playlist.coverUrl!,
                width: 52, height: 52, fit: BoxFit.cover)
            : Container(
                width: 52,
                height: 52,
                color: WaveColors.primary.withOpacity(0.2),
                child: const Icon(Icons.queue_music_rounded,
                    color: WaveColors.primary),
              ),
      ),
      title: Text(
        playlist.title,
        style: const TextStyle(
            color: WaveColors.textPrimary, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${playlist.trackCount} songs',
        style: const TextStyle(color: WaveColors.textMuted, fontSize: 12),
      ),
      trailing: const Icon(Icons.more_vert_rounded,
          color: WaveColors.textMuted, size: 20),
      onTap: () {},
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: WaveColors.textMuted, size: 64),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: WaveColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatePlaylistSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreatePlaylistSheet> createState() =>
      _CreatePlaylistSheetState();
}

class _CreatePlaylistSheetState extends ConsumerState<_CreatePlaylistSheet> {
  final _nameController = TextEditingController();
  bool _isPublic = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Playlist',
          style: TextStyle(
            color: WaveColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          autofocus: true,
          style: const TextStyle(color: WaveColors.textPrimary),
          decoration: const InputDecoration(
            labelText: 'Playlist name',
            hintText: 'My awesome playlist',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Switch(
              value: _isPublic,
              onChanged: (v) => setState(() => _isPublic = v),
            ),
            const SizedBox(width: 8),
            const Text('Make public',
                style: TextStyle(color: WaveColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Create playlist
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
