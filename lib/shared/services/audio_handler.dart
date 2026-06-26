import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class WavelengthAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  WavelengthAudioHandler() {
    _player.playbackEventStream.listen(_broadcastState);
    _player.durationStream.listen((duration) {
      if (mediaItem.value != null && duration != null) {
        mediaItem.add(mediaItem.value!.copyWith(duration: duration));
      }
    });

    // Forward position updates
    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: position,
        bufferedPosition: _player.bufferedPosition,
      ));
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (queue.value.isEmpty) return;
    final currentIndex = _player.currentIndex ?? 0;
    if (currentIndex < queue.value.length - 1) {
      await skipToQueueItem(currentIndex + 1);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final position = _player.position;
    if (position.inSeconds > 3) {
      await seek(Duration.zero);
    } else {
      final currentIndex = _player.currentIndex ?? 0;
      if (currentIndex > 0) {
        await skipToQueueItem(currentIndex - 1);
      }
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    await _player.seek(Duration.zero, index: index);
    await _player.play();
    mediaItem.add(queue.value[index]);
  }

  @override
  Future<void> addQueueItem(MediaItem item) async {
    final currentQueue = queue.value;
    final newQueue = [...currentQueue, item];
    queue.add(newQueue);

    final source = AudioSource.uri(Uri.parse(item.extras?['url'] ?? ''));
    if (_player.audioSource is ConcatenatingAudioSource) {
      await (_player.audioSource as ConcatenatingAudioSource).add(source);
    } else {
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: [source]),
      );
    }
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    queue.add(newQueue);
    final sources = newQueue
        .map((item) => AudioSource.uri(Uri.parse(item.extras?['url'] ?? '')))
        .toList();
    await _player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
    );
  }

  Future<void> playFromUrl(String url, MediaItem item) async {
    mediaItem.add(item);
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> setSpeed(double speed) => _player.setSpeed(speed);
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  void setLoopMode(LoopMode mode) => _player.setLoopMode(mode);
  void setShuffleModeEnabled(bool enabled) =>
      _player.setShuffleModeEnabled(enabled);

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  bool get playing => _player.playing;
  double get speed => _player.speed;

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    ));
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
