import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(ref.watch(supabaseProvider));
});

class SupabaseService {
  SupabaseService(this._client);

  final SupabaseClient _client;

  SupabaseClient get client => _client;

  // Auth helpers
  User? get currentUser => _client.auth.currentUser;
  Stream<AuthState> get authStateStream => _client.auth.onAuthStateChange;

  Future<AuthResponse> signInWithEmail(String email, String password) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<AuthResponse> signUpWithEmail(String email, String password) =>
      _client.auth.signUp(email: email, password: password);

  Future<AuthResponse> signInWithGoogle() =>
      _client.auth.signInWithOAuth(OAuthProvider.google);

  Future<AuthResponse> signInWithApple() =>
      _client.auth.signInWithOAuth(OAuthProvider.apple);

  Future<void> signOut() => _client.auth.signOut();

  Future<void> resetPassword(String email) =>
      _client.auth.resetPasswordForEmail(email);

  // User profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  Future<void> upsertUserProfile(Map<String, dynamic> data) async {
    await _client.from('user_profiles').upsert(data);
  }

  // Tracks
  Future<List<Map<String, dynamic>>> searchTracks(String query,
      {int limit = 30}) async {
    return await _client
        .from('tracks')
        .select('*, artists(*), albums(*)')
        .ilike('title', '%$query%')
        .limit(limit);
  }

  // Library
  Future<List<Map<String, dynamic>>> getLikedTracks(String userId,
      {int limit = 50, int offset = 0}) async {
    return await _client
        .from('user_library')
        .select('*, tracks(*, artists(*), albums(*))')
        .eq('user_id', userId)
        .eq('entity_type', 'track')
        .order('saved_at', ascending: false)
        .range(offset, offset + limit - 1);
  }

  Future<void> likeTrack(String userId, String trackId) async {
    await _client.from('user_library').upsert({
      'user_id': userId,
      'entity_type': 'track',
      'entity_id': trackId,
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> unlikeTrack(String userId, String trackId) async {
    await _client
        .from('user_library')
        .delete()
        .eq('user_id', userId)
        .eq('entity_type', 'track')
        .eq('entity_id', trackId);
  }

  // Play history
  Future<void> logPlay({
    required String userId,
    required String trackId,
    required String contextType,
    String? contextId,
    required int durationPlayedMs,
    required bool completed,
  }) async {
    await _client.from('listening_history').insert({
      'user_id': userId,
      'track_id': trackId,
      'context_type': contextType,
      'context_id': contextId,
      'duration_played_ms': durationPlayedMs,
      'completed': completed,
      'played_at': DateTime.now().toIso8601String(),
    });
  }

  // Playlists
  Future<List<Map<String, dynamic>>> getUserPlaylists(String userId) async {
    return await _client
        .from('playlists')
        .select()
        .eq('owner_id', userId)
        .order('updated_at', ascending: false);
  }

  Future<Map<String, dynamic>> createPlaylist({
    required String userId,
    required String title,
    String? description,
    bool isPublic = false,
  }) async {
    final response = await _client.from('playlists').insert({
      'owner_id': userId,
      'title': title,
      'description': description,
      'public': isPublic,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).select().single();
    return response;
  }

  Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
    final count = await _client
        .from('playlist_tracks')
        .select()
        .eq('playlist_id', playlistId)
        .count();

    await _client.from('playlist_tracks').insert({
      'playlist_id': playlistId,
      'track_id': trackId,
      'position': count.count,
      'added_at': DateTime.now().toIso8601String(),
    });
  }

  // Recommendations
  Future<List<Map<String, dynamic>>> getHomeRecommendations(
      String userId) async {
    return await _client
        .from('tracks')
        .select('*, artists(*), albums(*)')
        .limit(30);
  }

  // Artists
  Future<Map<String, dynamic>?> getArtist(String artistId) async {
    return await _client
        .from('artists')
        .select()
        .eq('id', artistId)
        .maybeSingle();
  }

  Future<List<Map<String, dynamic>>> getArtistTopTracks(
      String artistId) async {
    return await _client
        .from('tracks')
        .select('*, artists(*), albums(*)')
        .eq('artist_id', artistId)
        .order('play_count', ascending: false)
        .limit(10);
  }

  // Streaming URL generation (calls Edge Function)
  Future<String?> getStreamingUrl(String trackId, String quality) async {
    try {
      final response = await _client.functions.invoke(
        'streaming-url',
        body: {'track_id': trackId, 'quality': quality},
      );
      return response.data?['url'] as String?;
    } catch (_) {
      return null;
    }
  }
}
