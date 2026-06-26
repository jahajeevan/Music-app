import 'package:freezed_annotation/freezed_annotation.dart';
import 'artist.dart';
import 'album.dart';

part 'track.freezed.dart';
part 'track.g.dart';

enum AudioQuality { normal, high, veryHigh, lossless, hiResLossless, spatial }

@freezed
class Track with _$Track {
  const factory Track({
    required String id,
    required String title,
    required Artist artist,
    required Album album,
    required int durationMs,
    String? previewUrl,
    String? streamUrl,
    @Default(false) bool isExplicit,
    @Default(false) bool isLiked,
    @Default(false) bool isDownloaded,
    @Default([]) List<String> availableMarkets,
    @Default(false) bool hasLossless,
    @Default(false) bool hasSpatialAudio,
    @Default(false) bool hasLyrics,
    int? trackNumber,
    int? discNumber,
    String? isrc,
    Map<String, dynamic>? audioFeatures,
  }) = _Track;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}

extension TrackX on Track {
  String get formattedDuration {
    final minutes = durationMs ~/ 60000;
    final seconds = (durationMs % 60000) ~/ 1000;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get artistName => artist.name;
  String get albumTitle => album.title;
  String? get coverUrl => album.coverUrl;
}
