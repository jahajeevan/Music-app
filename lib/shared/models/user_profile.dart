import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

enum SubscriptionTier { free, premium, premiumPlus, family, student, artist }

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? countryCode,
    @Default(SubscriptionTier.free) SubscriptionTier subscription,
    @Default(false) bool isPublic,
    @Default(false) bool isArtist,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int totalMinutesListened,
    @Default([]) List<String> topGenres,
    DateTime? createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileX on UserProfile {
  String get displayNameOrEmail => displayName ?? email.split('@').first;

  bool get isPremium =>
      subscription != SubscriptionTier.free;

  bool get hasLossless =>
      subscription == SubscriptionTier.premiumPlus ||
      subscription == SubscriptionTier.family;
}
