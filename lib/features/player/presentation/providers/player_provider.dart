import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../main.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/services/supabase_service.dart';

// ── Current track ──────────────────────────────────────────────────────────────

final currentTrackProvider = StateProvider<Track?>((ref) => null);

final isPlayingProvider = StreamProvider<bool>((ref) {
  return audioHandler.playerStateStream.map((s) => s.playing);
});

final playbackPositionProvider = StreamProvider<Duration>((ref) {
  return audioHandler.positionStream;
});

final playbackDurationProvider = StreamProvider<Duration?>((ref) {
  return audioHandler.durationStream;
});

final playerStateProvider = StreamProvider<PlayerState>((ref) {
  return audioHandler.playerStateStream;
});

// ── Queue ──────────────────────────────────────────────────────────────────────

final queueProvider = StreamProvider<List<MediaItem>>((ref) {
  return audioHandler.queue;
});

// ── Repeat / shuffle ──────────────────────────────────────────────────────────

enum RepeatMode { off, one, all }

final repeatModeProvider = StateProvider<RepeatMode>((ref) => RepeatMode.off);

final shuffleEnabledProvider = StateProvider<bool>((ref) => false);

// ── Volume / speed ─────────────────────────────────────────────────────────────

final playbackSpeedProvider = StateProvider<double>((ref) => 1.0);

// ── Sleep timer ────────────────────────────────────────────────────────────────

final sleepTimerProvider =
    StateProvider<DateTime?>((ref) => null); // null = disabled

// ── Player controller ──────────────────────────────────────────────────────────

final playerControllerProvider = Provider<PlayerController>((ref) {
  return PlayerController(ref);
});

class PlayerController {
  PlayerController(this._ref);

  final Ref _ref;

  Future<void> playTrack(Track track, {String contextType = 'none', String? contextId}) async {
    final supabase = _ref.read(supabaseServiceProvider);
    final quality = _ref.read(audioQualityProvider);

    // Get streaming URL from backend
    final url = await supabase.getStreamingUrl(track.id, quality.name) ??
        track.previewUrl ??
        '';

    if (url.isEmpty) return;

    final mediaItem = MediaItem(
      id: track.id,
      title: track.title,
      artist: track.artistName,
      album: track.albumTitle,
      artUri: track.coverUrl != null ? Uri.parse(track.coverUrl!) : null,
      duration: Duration(milliseconds: track.durationMs),
      extras: {'url': url, 'context_type': contextType, 'context_id': contextId},
    );

    await audioHandler.playFromUrl(url, mediaItem);
    _ref.read(currentTrackProvider.notifier).state = track;
  }

  Future<void> togglePlayPause() async {
    if (audioHandler.playing) {
      await audioHandler.pause();
    } else {
      await audioHandler.play();
    }
  }

  Future<void> skipNext() => audioHandler.skipToNext();
  Future<void> skipPrevious() => audioHandler.skipToPrevious();

  Future<void> seek(Duration position) => audioHandler.seek(position);

  void toggleRepeat() {
    final current = _ref.read(repeatModeProvider);
    final next = switch (current) {
      RepeatMode.off => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.off,
    };
    _ref.read(repeatModeProvider.notifier).state = next;

    final loopMode = switch (next) {
      RepeatMode.off => LoopMode.off,
      RepeatMode.one => LoopMode.one,
      RepeatMode.all => LoopMode.all,
    };
    audioHandler.setLoopMode(loopMode);
  }

  void toggleShuffle() {
    final enabled = !_ref.read(shuffleEnabledProvider);
    _ref.read(shuffleEnabledProvider.notifier).state = enabled;
    audioHandler.setShuffleModeEnabled(enabled);
  }

  void setSpeed(double speed) {
    _ref.read(playbackSpeedProvider.notifier).state = speed;
    audioHandler.setSpeed(speed);
  }

  Future<void> playQueue(List<Track> tracks, {int startIndex = 0, String contextType = 'playlist', String? contextId}) async {
    final supabase = _ref.read(supabaseServiceProvider);
    final quality = _ref.read(audioQualityProvider);

    final mediaItems = <MediaItem>[];
    for (final track in tracks) {
      final url = await supabase.getStreamingUrl(track.id, quality.name) ??
          track.previewUrl ?? '';
      mediaItems.add(MediaItem(
        id: track.id,
        title: track.title,
        artist: track.artistName,
        album: track.albumTitle,
        artUri: track.coverUrl != null ? Uri.parse(track.coverUrl!) : null,
        duration: Duration(milliseconds: track.durationMs),
        extras: {'url': url},
      ));
    }

    await audioHandler.updateQueue(mediaItems);
    await audioHandler.skipToQueueItem(startIndex);
    _ref.read(currentTrackProvider.notifier).state = tracks[startIndex];
  }
}

// Audio quality preference
enum StreamingQuality { normal, high, veryHigh, lossless, hiResLossless }

final audioQualityProvider = StateProvider<StreamingQuality>((ref) {
  return StreamingQuality.high;
});
