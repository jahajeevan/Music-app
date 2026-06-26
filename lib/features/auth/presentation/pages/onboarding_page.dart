import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/color_tokens.dart';

const _genres = [
  (emoji: '🎵', name: 'Pop', color: Color(0xFFFF6B6B)),
  (emoji: '🎸', name: 'Rock', color: Color(0xFFFF8E53)),
  (emoji: '🎤', name: 'Hip-Hop', color: Color(0xFFFFD700)),
  (emoji: '🎹', name: 'R&B', color: Color(0xFF9B95FF)),
  (emoji: '🎻', name: 'Classical', color: Color(0xFF87CEEB)),
  (emoji: '🎺', name: 'Jazz', color: Color(0xFF00D4AA)),
  (emoji: '🎧', name: 'Electronic', color: Color(0xFF6C63FF)),
  (emoji: '🤠', name: 'Country', color: Color(0xFFCD853F)),
  (emoji: '💃', name: 'Latin', color: Color(0xFFFF69B4)),
  (emoji: '🌴', name: 'Reggae', color: Color(0xFF32CD32)),
  (emoji: '🎷', name: 'Blues', color: Color(0xFF4169E1)),
  (emoji: '🌍', name: 'Afrobeats', color: Color(0xFFFF8C00)),
  (emoji: '🇰🇷', name: 'K-Pop', color: Color(0xFFFF1493)),
  (emoji: '🕉️', name: 'Bollywood', color: Color(0xFFFF6347)),
  (emoji: '🎻', name: 'Folk', color: Color(0xFF8FBC8F)),
  (emoji: '⚡', name: 'Metal', color: Color(0xFF808080)),
];

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final Set<String> _selectedGenres = {};

  void _toggleGenre(String name) {
    setState(() {
      if (_selectedGenres.contains(name)) {
        _selectedGenres.remove(name);
      } else {
        _selectedGenres.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "What's your\ntaste in music?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: WaveColors.textPrimary,
                  letterSpacing: -1,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pick at least 3 genres to personalize your experience',
                style: TextStyle(color: WaveColors.textMuted, fontSize: 15),
              ),
              const SizedBox(height: 32),

              // Genre grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _genres.length,
                  itemBuilder: (_, i) {
                    final genre = _genres[i];
                    final selected = _selectedGenres.contains(genre.name);
                    return _GenreChip(
                      emoji: genre.emoji,
                      name: genre.name,
                      color: genre.color,
                      selected: selected,
                      onTap: () => _toggleGenre(genre.name),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Count indicator
              Center(
                child: Text(
                  '${_selectedGenres.length} selected',
                  style: TextStyle(
                    color: _selectedGenres.length >= 3
                        ? WaveColors.accent
                        : WaveColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedGenres.length >= 3
                      ? () => context.go(AppRoutes.home)
                      : null,
                  child: const Text("Let's go"),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Skip for now',
                      style: TextStyle(color: WaveColors.textMuted)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({
    required this.emoji,
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: selected ? color.withOpacity(0.25) : WaveColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? color : Colors.transparent,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: selected ? color : WaveColors.textPrimary,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: color, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
