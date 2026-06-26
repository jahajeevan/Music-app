import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/color_tokens.dart';

enum Mood { all, happy, chill, energetic, sad, romantic, focus, party }

final selectedMoodProvider = StateProvider<Mood>((ref) => Mood.all);

const _moods = [
  (mood: Mood.all, emoji: '🎵', label: 'All', color: WaveColors.primary),
  (mood: Mood.happy, emoji: '😊', label: 'Happy', color: WaveColors.moodHappy),
  (mood: Mood.chill, emoji: '😌', label: 'Chill', color: WaveColors.moodChill),
  (mood: Mood.energetic, emoji: '⚡', label: 'Energy', color: WaveColors.moodEnergetic),
  (mood: Mood.sad, emoji: '💙', label: 'Sad', color: WaveColors.moodSad),
  (mood: Mood.romantic, emoji: '💕', label: 'Romance', color: WaveColors.moodRomantic),
  (mood: Mood.focus, emoji: '🎯', label: 'Focus', color: WaveColors.moodFocus),
  (mood: Mood.party, emoji: '🎉', label: 'Party', color: WaveColors.moodParty),
];

class MoodSelector extends ConsumerWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedMoodProvider);

    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _moods.length,
        itemBuilder: (_, i) {
          final item = _moods[i];
          final isSelected = selected == item.mood;

          return GestureDetector(
            onTap: () =>
                ref.read(selectedMoodProvider.notifier).state = item.mood,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? item.color.withOpacity(0.2)
                    : WaveColors.surfaceCard,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isSelected ? item.color : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? item.color : WaveColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
