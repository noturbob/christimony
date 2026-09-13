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

/// Matches the `account` object's field set as it appears in every one of
/// these responses -- but NOT the same envelope. `GET /me` returns these
/// fields flattened at the top level, sibling to `onboarding`. Phone
/// verify and the OAuth endpoints (`POST /auth/{phone/verify,google,apple}`)
/// return `{ token, account: {...this shape...}, is_new_account,
/// onboarding }` -- `onboarding` is a top-level sibling of `account`
/// there too, not nested inside it. A repository parsing a sign-in
/// response must decode `Account.fromJson(body['account'])` and
/// `OnboardingStatus.fromJson(body['onboarding'])` separately; only
/// `/me`'s body can be handed to `Account.fromJson` directly. See
/// `../backend/README.md`'s Authentication section for both shapes in
/// full.
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
    // Nullable because this class also models the `account` sub-object
    // of a sign-in response, which never carries onboarding itself (see
    // the class doc comment) -- callers there must read
    // response['onboarding'] separately, not account.onboarding.
    OnboardingStatus? onboarding,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

String _accountTypeToJson(AccountType t) => t.toJson();
