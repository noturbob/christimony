// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vouch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Vouch _$VouchFromJson(Map<String, dynamic> json) => _Vouch(
  id: (json['id'] as num).toInt(),
  profileId: (json['profile_id'] as num).toInt(),
  voucherName: json['voucher_name'] as String,
  voucherRole: VoucherRole.fromJson(json['voucher_role'] as String?),
  status: _vouchStatusFromJson(json['status'] as String?),
);

Map<String, dynamic> _$VouchToJson(_Vouch instance) => <String, dynamic>{
  'id': instance.id,
  'profile_id': instance.profileId,
  'voucher_name': instance.voucherName,
  'voucher_role': instance.voucherRole,
  'status': _$VouchStatusEnumMap[instance.status]!,
};

const _$VouchStatusEnumMap = {
  VouchStatus.pending: 'pending',
  VouchStatus.verified: 'verified',
  VouchStatus.unknown: 'unknown',
};
