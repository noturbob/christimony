import 'package:freezed_annotation/freezed_annotation.dart';

part 'denomination.freezed.dart';
part 'denomination.g.dart';

/// Fetched from `GET /denominations`, never hardcoded — the seeded list
/// can change server-side.
@freezed
abstract class Denomination with _$Denomination {
  const factory Denomination({required int id, required String name}) =
      _Denomination;

  factory Denomination.fromJson(Map<String, dynamic> json) =>
      _$DenominationFromJson(json);
}
