import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../app/theme/color_tokens.dart';
import '../../features/player/presentation/widgets/mini_player.dart';
import '../../features/player/presentation/providers/player_provider.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentTrack = ref.watch(currentTrackProvider);
    final showMiniPlayer = currentTrack != null;

    final navItems = [
      (icon: Icons.home_rounded, label: 'Home', route: AppRoutes.home),
      (icon: Icons.search_rounded, label: 'Search', route: AppRoutes.search),
      (icon: Icons.explore_rounded, label: 'Discover', route: AppRoutes.discovery),
      (icon: Icons.library_music_rounded, label: 'Library', route: AppRoutes.library),
      (icon: Icons.people_rounded, label: 'Social', route: AppRoutes.social),
    ];

    int selectedIndex = navItems.indexWhere(
      (item) => location.startsWith(item.route),
    );
    if (selectedIndex < 0) selectedIndex = 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showMiniPlayer) const MiniPlayer(),
          _WaveBottomNav(
            items: navItems,
            selectedIndex: selectedIndex,
            onTap: (i) => context.go(navItems[i].route),
          ),
        ],
      ),
    );
  }
}

class _WaveBottomNav extends StatelessWidget {
  const _WaveBottomNav({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<({IconData icon, String label, String route})> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WaveColors.surface,
        border: Border(
          top: BorderSide(
            color: WaveColors.surfaceOverlay.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == selectedIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: selected
                              ? WaveColors.primary.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          item.icon,
                          color: selected
                              ? WaveColors.primary
                              : WaveColors.textMuted,
                          size: selected ? 26 : 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selected
                              ? WaveColors.primary
                              : WaveColors.textMuted,
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
