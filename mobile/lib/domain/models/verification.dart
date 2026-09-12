import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'verification.freezed.dart';
part 'verification.g.dart';

/// No capture flow exists behind any of these server-side — `Start` just
/// creates a `pending` record. Label that honestly in the UI (plan,
/// Phase 9).
@freezed
abstract class Verification with _$Verification {
  const factory Verification({
    required int id,
    @JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson)
    required VerificationType verificationType,
    @JsonKey(fromJson: VerificationStatus.fromJson)
    required VerificationStatus status,
    @JsonKey(name: 'verified_at') String? verifiedAt,
  }) = _Verification;

  factory Verification.fromJson(Map<String, dynamic> json) =>
      _$VerificationFromJson(json);
}
