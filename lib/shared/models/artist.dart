import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
class Artist with _$Artist {
  const factory Artist({
    required String id,
    required String name,
    String? imageUrl,
    String? bio,
    @Default(0) int monthlyListeners,
    @Default([]) List<String> genres,
    @Default(false) bool isVerified,
    @Default(false) bool isFollowed,
    String? countryCode,
    String? websiteUrl,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) =>
      _$ArtistFromJson(json);
}

@freezed
class ArtistDetail with _$ArtistDetail {
  const factory ArtistDetail({
    required Artist artist,
    @Default([]) List<dynamic> topTracks,
    @Default([]) List<dynamic> albums,
    @Default([]) List<Artist> relatedArtists,
    Map<String, dynamic>? upcomingEvent,
  }) = _ArtistDetail;

  factory ArtistDetail.fromJson(Map<String, dynamic> json) =>
      _$ArtistDetailFromJson(json);
}
