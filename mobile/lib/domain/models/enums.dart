/// Every string enum the Rails API validates against, mirrored here with
/// an `unknown` fallback so an unrecognised value from the server never
/// crashes deserialization — see `docs/mobile-v1-plan.md` §4.6.
library;

enum AccountType {
  individual,
  parent,
  unknown;

  static AccountType fromJson(String? value) => switch (value) {
    'individual' => AccountType.individual,
    'parent' => AccountType.parent,
    _ => AccountType.unknown,
  };

  String toJson() => name;
}

enum ProfileType {
  self,
  ward,
  unknown;

  static ProfileType fromJson(String? value) => switch (value) {
    'self' => ProfileType.self,
    'ward' => ProfileType.ward,
    _ => ProfileType.unknown,
  };

  String toJson() => name;
}

enum ProfileStatus {
  draft,
  active,
  paused,
  banned,
  unknown;

  static ProfileStatus fromJson(String? value) => switch (value) {
    'draft' => ProfileStatus.draft,
    'active' => ProfileStatus.active,
    'paused' => ProfileStatus.paused,
    'banned' => ProfileStatus.banned,
    _ => ProfileStatus.unknown,
  };

  String toJson() => name;
}

enum Gender {
  male,
  female,
  unknown;

  static Gender? fromJson(String? value) => switch (value) {
    'male' => Gender.male,
    'female' => Gender.female,
    null => null,
    _ => Gender.unknown,
  };

  String? toJson() => this == Gender.unknown ? null : name;
}

enum InterestStatus {
  pending,
  accepted,
  declined,
  unknown;

  static InterestStatus fromJson(String? value) => switch (value) {
    'pending' => InterestStatus.pending,
    'accepted' => InterestStatus.accepted,
    'declined' => InterestStatus.declined,
    _ => InterestStatus.unknown,
  };
}

enum MatchType {
  direct,
  parent,
  unknown;

  static MatchType fromJson(String? value) => switch (value) {
    'direct' => MatchType.direct,
    'parent' => MatchType.parent,
    _ => MatchType.unknown,
  };
}

enum IntroductionStatus {
  pendingBoth,
  pendingA,
  pendingB,
  accepted,
  declined,
  unknown;

  static IntroductionStatus fromJson(String? value) => switch (value) {
    'pending_both' => IntroductionStatus.pendingBoth,
    'pending_a' => IntroductionStatus.pendingA,
    'pending_b' => IntroductionStatus.pendingB,
    'accepted' => IntroductionStatus.accepted,
    'declined' => IntroductionStatus.declined,
    _ => IntroductionStatus.unknown,
  };
}

enum VerificationType {
  governmentId,
  selfieLiveness,
  phoneOtp,
  emailOtp,
  videoKyc,
  unknown;

  static VerificationType fromJson(String? value) => switch (value) {
    'government_id' => VerificationType.governmentId,
    'selfie_liveness' => VerificationType.selfieLiveness,
    'phone_otp' => VerificationType.phoneOtp,
    'email_otp' => VerificationType.emailOtp,
    'video_kyc' => VerificationType.videoKyc,
    _ => VerificationType.unknown,
  };

  String toJson() => switch (this) {
    VerificationType.governmentId => 'government_id',
    VerificationType.selfieLiveness => 'selfie_liveness',
    VerificationType.phoneOtp => 'phone_otp',
    VerificationType.emailOtp => 'email_otp',
    VerificationType.videoKyc => 'video_kyc',
    VerificationType.unknown => 'unknown',
  };
}

enum VerificationStatus {
  pending,
  verified,
  rejected,
  unknown;

  static VerificationStatus fromJson(String? value) => switch (value) {
    'pending' => VerificationStatus.pending,
    'verified' => VerificationStatus.verified,
    'rejected' => VerificationStatus.rejected,
    _ => VerificationStatus.unknown,
  };
}

enum SubscriptionPlan {
  free,
  premium,
  family,
  unknown;

  static SubscriptionPlan fromJson(String? value) => switch (value) {
    'free' => SubscriptionPlan.free,
    'premium' => SubscriptionPlan.premium,
    'family' => SubscriptionPlan.family,
    _ => SubscriptionPlan.unknown,
  };

  String toJson() => name;
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  unknown;

  static SubscriptionStatus fromJson(String? value) => switch (value) {
    'active' => SubscriptionStatus.active,
    'expired' => SubscriptionStatus.expired,
    'cancelled' => SubscriptionStatus.cancelled,
    _ => SubscriptionStatus.unknown,
  };
}

enum VoucherRole {
  pastor,
  elder,
  familyFriend,
  other,
  unknown;

  static VoucherRole fromJson(String? value) => switch (value) {
    'pastor' => VoucherRole.pastor,
    'elder' => VoucherRole.elder,
    'family_friend' => VoucherRole.familyFriend,
    'other' => VoucherRole.other,
    _ => VoucherRole.unknown,
  };

  String toJson() => switch (this) {
    VoucherRole.pastor => 'pastor',
    VoucherRole.elder => 'elder',
    VoucherRole.familyFriend => 'family_friend',
    VoucherRole.other => 'other',
    VoucherRole.unknown => 'unknown',
  };
}
