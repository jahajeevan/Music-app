import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/color_tokens.dart';

class SocialFeedPage extends ConsumerWidget {
  const SocialFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: WaveColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: WaveColors.bg,
            title: const Text(
              'Social',
              style: TextStyle(
                color: WaveColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.group_add_rounded,
                    color: WaveColors.textPrimary),
                onPressed: () {},
              ),
            ],
          ),

          // Friends listening now
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Text(
                    'Listening Now',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(
                  height: 96,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 6,
                    itemBuilder: (_, i) => _FriendStory(
                      name: ['Alex', 'Sara', 'Mike', 'Jess', 'Tom', 'Lily'][i],
                      avatarUrl:
                          'https://picsum.photos/seed/friend$i/100/100',
                      song: 'Track ${i + 1}',
                      isLive: i < 3,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Start listening party CTA
                _ListeningPartyCTA(),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: WaveColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Activity feed
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _FeedItem(index: i),
              childCount: 15,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _FriendStory extends StatelessWidget {
  const _FriendStory({
    required this.name,
    required this.avatarUrl,
    required this.song,
    required this.isLive,
  });

  final String name;
  final String avatarUrl;
  final String song;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLive ? WaveColors.primary : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(avatarUrl),
                ),
              ),
              if (isLive)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: WaveColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.music_note_rounded,
                            color: Colors.white, size: 8),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
              color: WaveColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            song,
            style: const TextStyle(color: WaveColors.textMuted, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ListeningPartyCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: WaveColors.gradientAccent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.headset_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start a Listening Party',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Invite friends to listen together in real-time',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white70, size: 14),
          ],
        ),
      ),
    );
  }
}

class _FeedItem extends StatelessWidget {
  const _FeedItem({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final types = ['shared', 'liked', 'party', 'shared', 'liked'];
    final type = types[index % types.length];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WaveColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(
                    'https://picsum.photos/seed/u$index/100/100'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User ${index + 1}',
                      style: const TextStyle(
                        color: WaveColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _activityText(type),
                      style: const TextStyle(
                          color: WaveColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Text(
                '${index + 1}m ago',
                style: const TextStyle(
                    color: WaveColors.textMuted, fontSize: 11),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Track card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WaveColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://picsum.photos/seed/track$index/100/100',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Track Title',
                          style: TextStyle(
                            color: WaveColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          )),
                      Text('Artist Name',
                          style: TextStyle(
                              color: WaveColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_filled_rounded,
                    color: WaveColors.primary, size: 36),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Reactions row
          Row(
            children: [
              _ReactionButton(emoji: '❤️', count: index * 3 + 12),
              const SizedBox(width: 12),
              _ReactionButton(emoji: '🔥', count: index + 5),
              const SizedBox(width: 12),
              _ReactionButton(emoji: '💬', count: index * 2 + 1),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share_outlined,
                    color: WaveColors.textMuted, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _activityText(String type) => switch (type) {
        'shared' => 'shared a track',
        'liked' => 'liked a song',
        'party' => 'started a listening party',
        _ => 'is listening to',
      };
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({required this.emoji, required this.count});

  final String emoji;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: WaveColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: const TextStyle(
                  color: WaveColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
