import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

/// No payment gateway is wired up server-side, and Apple requires
/// StoreKit (not Razorpay) for digital subscriptions — v1 renders this
/// data as informational only, with no purchase flow. See plan Phase 9 /
/// §6 (Risks).
@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    required int id,
    @JsonKey(fromJson: SubscriptionPlan.fromJson)
    required SubscriptionPlan plan,
    @JsonKey(fromJson: SubscriptionStatus.fromJson)
    required SubscriptionStatus status,
    @JsonKey(name: 'started_at') required String startedAt,
    @JsonKey(name: 'expires_at') String? expiresAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
