import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/auth_token_holder.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// Constructs Dio exactly once for the app's lifetime.
///
/// This provider watches [authTokenHolderProvider] — a stable-identity
/// object — NOT session state directly. If it watched the session
/// controller, every login/logout would rebuild Dio and orphan in-flight
/// requests and their `CancelToken`s. See `docs/mobile-v1-plan.md` §4.2.
///
/// Interceptor order: request interceptors run in LIST order; response
/// and error interceptors run in REVERSE list order. So on the way out:
/// Logging sees the raw wire response/error first, then Retry gets a
/// chance to resolve it before anything else sees a failure, then Error
/// normalizes the status/body into an `ApiException`, then Auth's 401
/// handler runs last and can pattern-match on the typed exception.
final dioProvider = Provider<Dio>((ref) {
  final holder = ref.watch(authTokenHolderProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: '${AppConfig.apiBaseUrl}/api/v1',
      connectTimeout: const Duration(seconds: 10),
      // The feed does inline ActiveStorage variant processing per photo
      // server-side (a pending Phase 1 fix) — give it room until that
      // lands.
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(holder),
    ErrorInterceptor(),
    RetryInterceptor(dio),
    if (kDebugMode) LoggingInterceptor(),
  ]);

  return dio;
});
