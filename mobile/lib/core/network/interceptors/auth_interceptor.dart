import 'dart:async';

import 'package:dio/dio.dart';

import '../../storage/auth_token_holder.dart';
import '../api_exception.dart';
import '../endpoints.dart';

/// Attaches `Authorization: Bearer <token>` to every non-public request,
/// and reacts to a normalized 401 by triggering force-logout exactly
/// once per session.
///
/// Extends [QueuedInterceptor] rather than plain [Interceptor] so error
/// handling is serialized: once token-refresh lands (currently stubbed —
/// see `AppConfig.refreshEnabled` and plan §4.2), ten concurrent 401s
/// must produce exactly one refresh attempt, with the other nine awaiting
/// it and retrying rather than each independently racing to refresh.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._holder);

  final AuthTokenHolder _holder;
  bool _loggingOut = false;

  static final Set<String> _publicPathSuffixes = Api.publicPaths
      .map((e) => e.template)
      .toSet();

  bool _isPublic(String path) {
    return _publicPathSuffixes.any((suffix) => path.endsWith(suffix));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _holder.token;
    if (token != null && !_isPublic(options.path)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = err.error;
    final isPublic = _isPublic(err.requestOptions.path);

    if (error is Unauthorized && !isPublic && !_loggingOut) {
      _loggingOut = true;
      _holder.onUnauthenticated?.call();
      // Reset on the next tick so a fresh login can trigger force-logout
      // again in a later session without needing a new AuthInterceptor
      // instance.
      scheduleMicrotask(() => _loggingOut = false);
    }

    handler.next(err);
  }
}
