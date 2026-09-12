import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'vouch.freezed.dart';
part 'vouch.g.dart';

@freezed
abstract class Vouch with _$Vouch {
  const factory Vouch({
    required int id,
    @JsonKey(name: 'profile_id') required int profileId,
    @JsonKey(name: 'voucher_name') required String voucherName,
    @JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson)
    required VoucherRole voucherRole,
    @JsonKey(fromJson: _vouchStatusFromJson) required VouchStatus status,
  }) = _Vouch;

  factory Vouch.fromJson(Map<String, dynamic> json) => _$VouchFromJson(json);
}

enum VouchStatus { pending, verified, unknown }

VouchStatus _vouchStatusFromJson(String? value) => switch (value) {
  'pending' => VouchStatus.pending,
  'verified' => VouchStatus.verified,
  _ => VouchStatus.unknown,
};
