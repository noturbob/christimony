import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class OnboardingStatus with _$OnboardingStatus {
  const factory OnboardingStatus({
    required bool complete,
    @JsonKey(name: 'profile_id') int? profileId,
  }) = _OnboardingStatus;

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusFromJson(json);
}

/// Matches `AccountsController#me`, `PhoneAuthController#verify`, and the
/// OAuth controllers' response shape (`docs/mobile-v1-plan.md` notes the
/// key ORDER differs between them but the key SET is identical).
@freezed
abstract class Account with _$Account {
  const factory Account({
    required int id,
    String? email,
    String? phone,
    @JsonKey(name: 'phone_verified_at') String? phoneVerifiedAt,
    @JsonKey(
      name: 'account_type',
      fromJson: AccountType.fromJson,
      toJson: _accountTypeToJson,
    )
    required AccountType accountType,
    // Only present on GET /me and the auth endpoints — a plain OAuth
    // "account" sub-object embedded elsewhere in a response won't carry
    // this, hence nullable.
    OnboardingStatus? onboarding,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

String _accountTypeToJson(AccountType t) => t.toJson();
