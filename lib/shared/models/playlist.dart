import 'package:freezed_annotation/freezed_annotation.dart';
import 'track.dart';

part 'playlist.freezed.dart';
part 'playlist.g.dart';

@freezed
class Playlist with _$Playlist {
  const factory Playlist({
    required String id,
    required String title,
    required String ownerId,
    String? ownerName,
    String? description,
    String? coverUrl,
    @Default(false) bool isPublic,
    @Default(false) bool isCollaborative,
    @Default(false) bool isSmart,
    @Default(0) int trackCount,
    @Default(0) int totalDurationMs,
    @Default([]) List<Track> tracks,
    @Default([]) List<String> genres,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Playlist;

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
}

extension PlaylistX on Playlist {
  String get formattedDuration {
    final hours = totalDurationMs ~/ 3600000;
    final minutes = (totalDurationMs % 3600000) ~/ 60000;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}

@freezed
class QueueItem with _$QueueItem {
  const factory QueueItem({
    required String id,
    required Track track,
    required String contextId,
    required String contextType,
    @Default(false) bool isNext,
  }) = _QueueItem;

  factory QueueItem.fromJson(Map<String, dynamic> json) =>
      _$QueueItemFromJson(json);
}
