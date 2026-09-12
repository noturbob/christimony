// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingStatus _$OnboardingStatusFromJson(Map<String, dynamic> json) =>
    _OnboardingStatus(
      complete: json['complete'] as bool,
      profileId: (json['profile_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OnboardingStatusToJson(_OnboardingStatus instance) =>
    <String, dynamic>{
      'complete': instance.complete,
      'profile_id': instance.profileId,
    };

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  phoneVerifiedAt: json['phone_verified_at'] as String?,
  accountType: AccountType.fromJson(json['account_type'] as String?),
  onboarding: json['onboarding'] == null
      ? null
      : OnboardingStatus.fromJson(json['onboarding'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'phone': instance.phone,
  'phone_verified_at': instance.phoneVerifiedAt,
  'account_type': _accountTypeToJson(instance.accountType),
  'onboarding': instance.onboarding,
};
