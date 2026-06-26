import 'package:flutter/material.dart';
import '../../../../app/theme/color_tokens.dart';

const _genreItems = [
  (name: 'Pop', icon: Icons.music_note_rounded, color: Color(0xFFFF6B6B)),
  (name: 'Hip-Hop', icon: Icons.headphones_rounded, color: Color(0xFFFFD700)),
  (name: 'Rock', icon: Icons.electric_bolt_rounded, color: Color(0xFFFF8E53)),
  (name: 'Electronic', icon: Icons.graphic_eq_rounded, color: Color(0xFF6C63FF)),
  (name: 'R&B', icon: Icons.favorite_rounded, color: Color(0xFF9B95FF)),
  (name: 'Jazz', icon: Icons.piano_rounded, color: Color(0xFF00D4AA)),
  (name: 'Classical', icon: Icons.library_music_rounded, color: Color(0xFF87CEEB)),
  (name: 'K-Pop', icon: Icons.star_rounded, color: Color(0xFFFF69B4)),
  (name: 'Latin', icon: Icons.nightlife_rounded, color: Color(0xFFFF69B4)),
  (name: 'Afrobeats', icon: Icons.language_rounded, color: Color(0xFFFF8C00)),
  (name: 'Bollywood', icon: Icons.festival_rounded, color: Color(0xFFFF6347)),
  (name: 'Podcasts', icon: Icons.podcasts_rounded, color: Color(0xFF4CAF50)),
  (name: 'Charts', icon: Icons.trending_up_rounded, color: Color(0xFF2196F3)),
  (name: 'New Releases', icon: Icons.fiber_new_rounded, color: Color(0xFF9C27B0)),
  (name: 'Mood', icon: Icons.mood_rounded, color: Color(0xFFFF9800)),
  (name: 'Workout', icon: Icons.fitness_center_rounded, color: Color(0xFFF44336)),
  (name: 'Focus', icon: Icons.self_improvement_rounded, color: Color(0xFF009688)),
  (name: 'Sleep', icon: Icons.bedtime_rounded, color: Color(0xFF3F51B5)),
];

class GenreBrowseGrid extends StatelessWidget {
  const GenreBrowseGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Text(
            'Browse all',
            style: TextStyle(
              color: WaveColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _genreItems.length,
            itemBuilder: (_, i) {
              final item = _genreItems[i];
              return _GenreCell(
                name: item.name,
                icon: item.icon,
                color: item.color,
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GenreCell extends StatelessWidget {
  const _GenreCell({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
