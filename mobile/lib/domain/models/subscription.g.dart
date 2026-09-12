// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    _Subscription(
      id: (json['id'] as num).toInt(),
      plan: SubscriptionPlan.fromJson(json['plan'] as String?),
      status: SubscriptionStatus.fromJson(json['status'] as String?),
      startedAt: json['started_at'] as String,
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$SubscriptionToJson(_Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plan': instance.plan,
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'started_at': instance.startedAt,
      'expires_at': instance.expiresAt,
    };

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.cancelled: 'cancelled',
  SubscriptionStatus.unknown: 'unknown',
};
