import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// A ~30-line debug-only request/response logger — deliberately not a
/// dependency like `talker_dio_logger`, which pulls in a whole logging UI
/// framework for something this small. Gated on [kDebugMode] so it never
/// ships in a release build. Runs FIRST in the response/error chain
/// (added last in the interceptor list — see `dio_provider.dart`) so it
/// logs the raw wire response before `ErrorInterceptor` normalizes it.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    debugPrint(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '✗ ${err.response?.statusCode} ${err.requestOptions.method} '
      '${err.requestOptions.uri} — ${err.message}',
    );
    handler.next(err);
  }
}
