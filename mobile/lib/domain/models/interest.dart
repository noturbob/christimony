import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'interest.freezed.dart';
part 'interest.g.dart';

@freezed
abstract class Interest with _$Interest {
  const factory Interest({
    required int id,
    @JsonKey(name: 'sender_profile_id') required int senderProfileId,
    @JsonKey(name: 'receiver_profile_id') required int receiverProfileId,
    @JsonKey(fromJson: InterestStatus.fromJson) required InterestStatus status,
  }) = _Interest;

  factory Interest.fromJson(Map<String, dynamic> json) =>
      _$InterestFromJson(json);
}
