import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import '../api_exception.dart';

/// Retries a request when it's safe and likely to help — never anything
/// else. See `docs/mobile-v1-plan.md` §4.2:
///
/// - Only [NetworkFailure] or a 5xx [ServerFailure].
/// - Only `GET` requests — never a write, and never a request whose body
///   is [FormData] (the multipart stream is single-read; a retry would
///   send an empty body).
/// - At most 2 attempts, with 400ms → 1200ms backoff and ±25% jitter.
/// - Never 429 — the OTP screen owns that cooldown UI using the
///   `retry_after` value the server returns in the 200 body; Rails sends
///   no `Retry-After` header to key off automatically.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, {Random? random}) : _random = random ?? Random();

  final Dio _dio;
  final Random _random;

  static const _delays = [
    Duration(milliseconds: 400),
    Duration(milliseconds: 1200),
  ];
  static const _attemptKey = 'retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 0;
    if (attempt >= _delays.length) {
      handler.next(err);
      return;
    }

    final base = _delays[attempt];
    final jitterMs =
        (base.inMilliseconds * 0.25 * (_random.nextDouble() * 2 - 1)).round();
    await Future<void>.delayed(base + Duration(milliseconds: jitterMs));

    try {
      final options = err.requestOptions;
      options.extra[_attemptKey] = attempt + 1;
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldRetry(DioException err) {
    if (err.requestOptions.method.toUpperCase() != 'GET') return false;
    if (err.requestOptions.data is FormData) return false;

    final error = err.error;
    if (error is NetworkFailure) return true;
    if (error is ServerFailure && (error.status ?? 0) >= 500) return true;
    return false;
  }
}
