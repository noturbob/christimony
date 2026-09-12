import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';
import 'photo.dart';
import 'prompt.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// Matches `ProfileSerialization#profile_json` — used by index / feed /
/// show / create / update.
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required int id,
    required String name,
    @JsonKey(
      name: 'profile_type',
      fromJson: ProfileType.fromJson,
      toJson: _profileTypeToJson,
    )
    required ProfileType profileType,
    // Bare civil date string ("1998-04-02") — parse with
    // core/utils/dates.dart's parseCivilDate, never .toLocal().
    String? dob,
    int? age,
    @JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson) Gender? gender,
    String? city,
    String? education,
    String? profession,
    String? bio,
    @JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson)
    required ProfileStatus status,
    @JsonKey(name: 'denomination_id') int? denominationId,
    String? denomination,
    @Default([]) List<PhotoRef> photos,
    @Default([]) List<Prompt> prompts,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

/// Matches `ProfileSerialization#profile_summary` — embedded in matches,
/// introductions, and conversations. `cover_photo_url` is nullable
/// (`profile.profile_photos.first&.then {...}`): every list/card
/// rendering this needs an initials-avatar fallback, not a broken-image
/// box. See plan §4.6.9.
@freezed
abstract class ProfileSummary with _$ProfileSummary {
  const factory ProfileSummary({
    required int id,
    required String name,
    String? city,
    @JsonKey(
      name: 'profile_type',
      fromJson: ProfileType.fromJson,
      toJson: _profileTypeToJson,
    )
    required ProfileType profileType,
    int? age,
    @JsonKey(name: 'cover_photo_url') String? coverPhotoUrl,
  }) = _ProfileSummary;

  factory ProfileSummary.fromJson(Map<String, dynamic> json) =>
      _$ProfileSummaryFromJson(json);
}

String _profileTypeToJson(ProfileType t) => t.toJson();
String _profileStatusToJson(ProfileStatus s) => s.toJson();
String? _genderToJson(Gender? g) => g?.toJson();
