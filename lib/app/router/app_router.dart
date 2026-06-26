import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/library/presentation/pages/library_page.dart';
import '../../features/discovery/presentation/pages/discovery_page.dart';
import '../../features/artist/presentation/pages/artist_page.dart';
import '../../features/player/presentation/pages/full_player_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/social/presentation/pages/social_feed_page.dart';
import '../../features/social/presentation/pages/listening_party_page.dart';
import '../../features/karaoke/presentation/pages/karaoke_page.dart';
import '../../features/ai_features/presentation/pages/ai_dj_page.dart';
import '../../features/premium/presentation/pages/premium_page.dart';
import '../../shared/widgets/main_scaffold.dart';

// Named routes
class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const search = '/search';
  static const library = '/library';
  static const discovery = '/discovery';
  static const social = '/social';
  static const artist = '/artist/:id';
  static const album = '/album/:id';
  static const playlist = '/playlist/:id';
  static const fullPlayer = '/player';
  static const settings = '/settings';
  static const listeningParty = '/party/:id';
  static const karaoke = '/karaoke/:trackId';
  static const aiDj = '/ai-dj';
  static const premium = '/premium';
  static const profile = '/profile/:userId';
  static const likedSongs = '/library/liked';
  static const downloads = '/library/downloads';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final user = Supabase.instance.client.auth.currentUser;
      final isLoggedIn = user != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup ||
          state.matchedLocation == AppRoutes.onboarding;

      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && isAuthRoute) return AppRoutes.home;
      return null;
    },
    routes: [
      // Auth routes (no shell)
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignupPage()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingPage(),
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: AppRoutes.fullPlayer,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const FullPlayerPage(),
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.karaoke,
        builder: (_, state) =>
            KaraokePage(trackId: state.pathParameters['trackId']!),
      ),
      GoRoute(path: AppRoutes.aiDj, builder: (_, __) => const AiDjPage()),
      GoRoute(
        path: AppRoutes.listeningParty,
        builder: (_, state) =>
            ListeningPartyPage(partyId: state.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.premium, builder: (_, __) => const PremiumPage()),

      // Shell route with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (_, __) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: AppRoutes.search,
            pageBuilder: (_, __) => const NoTransitionPage(child: SearchPage()),
          ),
          GoRoute(
            path: AppRoutes.library,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: LibraryPage()),
          ),
          GoRoute(
            path: AppRoutes.discovery,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: DiscoveryPage()),
          ),
          GoRoute(
            path: AppRoutes.social,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: SocialFeedPage()),
          ),
          GoRoute(
            path: AppRoutes.artist,
            builder: (_, state) =>
                ArtistPage(artistId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, __) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page not found', style: TextStyle(fontSize: 18)),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
