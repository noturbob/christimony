// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Verification _$VerificationFromJson(Map<String, dynamic> json) =>
    _Verification(
      id: (json['id'] as num).toInt(),
      verificationType: VerificationType.fromJson(
        json['verification_type'] as String?,
      ),
      status: VerificationStatus.fromJson(json['status'] as String?),
      verifiedAt: json['verified_at'] as String?,
    );

Map<String, dynamic> _$VerificationToJson(_Verification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'verification_type': instance.verificationType,
      'status': _$VerificationStatusEnumMap[instance.status]!,
      'verified_at': instance.verifiedAt,
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.unknown: 'unknown',
};
