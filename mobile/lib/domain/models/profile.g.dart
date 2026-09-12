// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  profileType: ProfileType.fromJson(json['profile_type'] as String?),
  dob: json['dob'] as String?,
  age: (json['age'] as num?)?.toInt(),
  gender: Gender.fromJson(json['gender'] as String?),
  city: json['city'] as String?,
  education: json['education'] as String?,
  profession: json['profession'] as String?,
  bio: json['bio'] as String?,
  status: ProfileStatus.fromJson(json['status'] as String?),
  denominationId: (json['denomination_id'] as num?)?.toInt(),
  denomination: json['denomination'] as String?,
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => PhotoRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  prompts:
      (json['prompts'] as List<dynamic>?)
          ?.map((e) => Prompt.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'profile_type': _profileTypeToJson(instance.profileType),
  'dob': instance.dob,
  'age': instance.age,
  'gender': _genderToJson(instance.gender),
  'city': instance.city,
  'education': instance.education,
  'profession': instance.profession,
  'bio': instance.bio,
  'status': _profileStatusToJson(instance.status),
  'denomination_id': instance.denominationId,
  'denomination': instance.denomination,
  'photos': instance.photos,
  'prompts': instance.prompts,
};

_ProfileSummary _$ProfileSummaryFromJson(Map<String, dynamic> json) =>
    _ProfileSummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      city: json['city'] as String?,
      profileType: ProfileType.fromJson(json['profile_type'] as String?),
      age: (json['age'] as num?)?.toInt(),
      coverPhotoUrl: json['cover_photo_url'] as String?,
    );

Map<String, dynamic> _$ProfileSummaryToJson(_ProfileSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'profile_type': _profileTypeToJson(instance.profileType),
      'age': instance.age,
      'cover_photo_url': instance.coverPhotoUrl,
    };
