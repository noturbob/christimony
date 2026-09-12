import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo.freezed.dart';
part 'photo.g.dart';

/// `url`/`thumb_url` are ActiveStorage 302-redirect URLs — permanently
/// signed and unauthenticated, safe to cache indefinitely. See
/// `docs/mobile-v1-plan.md` §4.6.12: a device on a LAN gets photo URLs
/// pointing at that LAN IP, since Rails builds them from
/// `request.base_url`.
@freezed
abstract class PhotoRef with _$PhotoRef {
  const factory PhotoRef({
    required int id,
    required String url,
    @JsonKey(name: 'thumb_url') required String thumbUrl,
    required int position,
  }) = _PhotoRef;

  factory PhotoRef.fromJson(Map<String, dynamic> json) =>
      _$PhotoRefFromJson(json);
}
