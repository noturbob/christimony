import 'package:dio/dio.dart';

import '../error_mapper.dart';

/// Normalizes every Dio error into a typed `ApiException` via the pure
/// [mapError] function, and stashes it on `err.error` so downstream code
/// (repositories, the auth interceptor) never has to re-parse the
/// response body.
///
/// Interceptor ORDER matters here: response/error interceptors run in
/// REVERSE of the list order they were added in, so this must be added
/// before `AuthInterceptor` for `AuthInterceptor`'s `onError` to see the
/// already-normalized exception. See `dio_provider.dart`.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.response == null) {
      handler.next(err.copyWith(error: mapError(null, null)));
      return;
    }

    final mapped = mapError(err.response?.statusCode, err.response?.data);
    handler.next(err.copyWith(error: mapped));
  }
}
