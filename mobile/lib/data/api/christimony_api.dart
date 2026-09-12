import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exception.dart';
import '../../core/network/dio_provider.dart';
import '../../core/network/endpoints.dart';

final christimonyApiProvider = Provider<ChristimonyApi>((ref) {
  return ChristimonyApi(ref.watch(dioProvider));
});

/// The only class in the app allowed to call [Dio] directly (enforced by
/// `tool/check_isolation.sh` in CI). Every endpoint gets one typed method
/// here; repositories call only this class, never Dio.
///
/// `send` is where the [Envelope] hazard described in
/// `docs/mobile-v1-plan.md` §4.2 is closed: the wrapping decision is made
/// mechanically from the [Endpoint] itself, so a call site cannot forget
/// (or wrongly add) a `{"profile": {...}}` wrapper.
class ChristimonyApi {
  ChristimonyApi(this._dio);

  final Dio _dio;

  /// Low-level send. `fields` is the flat field map for a JSON body —
  /// `send` wraps it per [Endpoint.envelope]. Pass `form` instead for a
  /// multipart request (photo upload); the two are mutually exclusive.
  Future<T> send<T>(
    Endpoint endpoint, {
    Map<String, Object> pathArgs = const {},
    Map<String, Object?>? fields,
    FormData? form,
    Map<String, Object?>? query,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    required T Function(Object? json) decode,
  }) async {
    final body =
        form ??
        (fields == null
            ? null
            : switch (endpoint.envelope) {
                Envelope.none => fields,
                Envelope.profile => {'profile': fields},
                Envelope.prompt => {'prompt': fields},
              });

    try {
      final response = await _dio.request<Object?>(
        endpoint.path(pathArgs),
        data: body,
        queryParameters: query,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(method: endpoint.method),
      );
      return decode(response.data);
    } on DioException catch (e) {
      final mapped = e.error;
      if (mapped is ApiException) throw mapped;
      throw const Unexpected(null);
    }
  }
}
