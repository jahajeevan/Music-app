import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../shared/models/user_profile.dart';
import '../../../../shared/services/supabase_service.dart';

// Current auth session
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(supabaseProvider).auth.currentUser;
});

// Current user profile
final userProfileProvider =
    FutureProvider.autoDispose<UserProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final service = ref.watch(supabaseServiceProvider);
  final data = await service.getUserProfile(user.id);
  if (data == null) return null;

  return UserProfile(
    id: data['id'] as String,
    email: data['email'] as String? ?? user.email ?? '',
    displayName: data['display_name'] as String?,
    avatarUrl: data['avatar_url'] as String?,
    bio: data['bio'] as String?,
    countryCode: data['country_code'] as String?,
    isPublic: data['is_public'] as bool? ?? false,
    isArtist: data['is_artist'] as bool? ?? false,
    followersCount: data['followers_count'] as int? ?? 0,
    followingCount: data['following_count'] as int? ?? 0,
  );
});

// Auth controller
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<bool> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final service = _ref.read(supabaseServiceProvider);
      await service.signInWithEmail(email, password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final service = _ref.read(supabaseServiceProvider);
      final response = await service.signUpWithEmail(email, password);
      if (response.user != null) {
        await service.upsertUserProfile({
          'id': response.user!.id,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final service = _ref.read(supabaseServiceProvider);
      await service.signInWithGoogle();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    state = const AsyncValue.loading();
    try {
      final service = _ref.read(supabaseServiceProvider);
      await service.signInWithApple();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> signOut() async {
    final service = _ref.read(supabaseServiceProvider);
    await service.signOut();
  }

  Future<void> resetPassword(String email) async {
    final service = _ref.read(supabaseServiceProvider);
    await service.resetPassword(email);
  }
}
