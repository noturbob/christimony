// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingDraft _$OnboardingDraftFromJson(Map<String, dynamic> json) =>
    _OnboardingDraft(
      accountType: json['accountType'] as String? ?? 'individual',
      name: json['name'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      denominationId: (json['denominationId'] as num?)?.toInt(),
      denominationName: json['denominationName'] as String? ?? '',
      city: json['city'] as String? ?? '',
      education: json['education'] as String? ?? '',
      profession: json['profession'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      profileId: (json['profileId'] as num?)?.toInt(),
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      answers:
          (json['answers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      savedPrompts:
          (json['savedPrompts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      step: json['step'] as String? ?? 'account-type',
    );

Map<String, dynamic> _$OnboardingDraftToJson(_OnboardingDraft instance) =>
    <String, dynamic>{
      'accountType': instance.accountType,
      'name': instance.name,
      'dob': instance.dob,
      'gender': instance.gender,
      'denominationId': instance.denominationId,
      'denominationName': instance.denominationName,
      'city': instance.city,
      'education': instance.education,
      'profession': instance.profession,
      'bio': instance.bio,
      'profileId': instance.profileId,
      'photos': instance.photos,
      'answers': instance.answers,
      'savedPrompts': instance.savedPrompts,
      'step': instance.step,
    };
