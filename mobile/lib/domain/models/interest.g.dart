// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Interest _$InterestFromJson(Map<String, dynamic> json) => _Interest(
  id: (json['id'] as num).toInt(),
  senderProfileId: (json['sender_profile_id'] as num).toInt(),
  receiverProfileId: (json['receiver_profile_id'] as num).toInt(),
  status: InterestStatus.fromJson(json['status'] as String?),
);

Map<String, dynamic> _$InterestToJson(_Interest instance) => <String, dynamic>{
  'id': instance.id,
  'sender_profile_id': instance.senderProfileId,
  'receiver_profile_id': instance.receiverProfileId,
  'status': _$InterestStatusEnumMap[instance.status]!,
};

const _$InterestStatusEnumMap = {
  InterestStatus.pending: 'pending',
  InterestStatus.accepted: 'accepted',
  InterestStatus.declined: 'declined',
  InterestStatus.unknown: 'unknown',
};
