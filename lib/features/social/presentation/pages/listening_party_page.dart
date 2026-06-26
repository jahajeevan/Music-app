import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/color_tokens.dart';

class ListeningPartyPage extends ConsumerWidget {
  const ListeningPartyPage({super.key, required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: WaveColors.playerBgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: WaveColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text('Listening Party',
                            style: TextStyle(
                                color: WaveColors.textMuted,
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600)),
                        Text('Friday Night Vibes',
                            style: TextStyle(
                                color: WaveColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: WaveColors.error.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: WaveColors.error.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: WaveColors.error, size: 8),
                        SizedBox(width: 5),
                        Text('LIVE',
                            style: TextStyle(
                                color: WaveColors.error,
                                fontSize: 11,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Album art
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: WaveColors.primary.withOpacity(0.3),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CachedNetworkImage(
                      imageUrl: 'https://picsum.photos/seed/party/400/400',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Track info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Blinding Lights',
                    style: TextStyle(
                        color: WaveColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                  const Text('The Weeknd',
                      style: TextStyle(
                          color: WaveColors.textMuted, fontSize: 15)),
                  const SizedBox(height: 16),
                  // Progress bar
                  const LinearProgressIndicator(
                    value: 0.45,
                    backgroundColor: WaveColors.waveformInactive,
                    valueColor: AlwaysStoppedAnimation(WaveColors.primary),
                    minHeight: 3,
                  ),
                ],
              ),
            ),

            // Listeners row
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text('12 listening',
                            style: TextStyle(
                                color: WaveColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 12,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: CachedNetworkImageProvider(
                              'https://picsum.photos/seed/p$i/100/100'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chat area
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: WaveColors.surfaceCard,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: WaveColors.surfaceOverlay,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: 8,
                        itemBuilder: (_, i) => _ChatMessage(index: i),
                      ),
                    ),
                    _ChatInput(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final messages = [
      '🔥 This track slaps!',
      '❤️ Love this',
      'Omg yes!!!',
      '🎵',
      'The bass in this is insane',
      '💃 dancing in my room rn',
      'skip this one',
      '🔥🔥🔥',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: CachedNetworkImageProvider(
                'https://picsum.photos/seed/c$index/50/50'),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ${index + 1}',
                  style: const TextStyle(
                      color: WaveColors.textMuted, fontSize: 10)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: WaveColors.surfaceElevated,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  messages[index % messages.length],
                  style: const TextStyle(
                      color: WaveColors.textPrimary, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            // Quick reactions
            for (final emoji in ['🔥', '❤️', '😮', '💃'])
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: const TextStyle(
                    color: WaveColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'React...',
                  hintStyle: const TextStyle(color: WaveColors.textMuted),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: WaveColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
