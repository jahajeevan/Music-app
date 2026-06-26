import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';
part 'album.g.dart';

enum AlbumType { album, single, ep, compilation }

@freezed
class Album with _$Album {
  const factory Album({
    required String id,
    required String title,
    required String artistId,
    required String artistName,
    String? coverUrl,
    String? releaseDate,
    @Default(AlbumType.album) AlbumType type,
    @Default(0) int totalTracks,
    @Default([]) List<String> availableMarkets,
    @Default(false) bool isSaved,
    String? label,
    String? upc,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}

extension AlbumX on Album {
  String get releaseYear => releaseDate?.substring(0, 4) ?? '';

  String get typeLabel => switch (type) {
        AlbumType.album => 'Album',
        AlbumType.single => 'Single',
        AlbumType.ep => 'EP',
        AlbumType.compilation => 'Compilation',
      };
}
