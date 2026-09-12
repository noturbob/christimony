import 'api_exception.dart';

/// Maps a raw HTTP response into a typed [ApiException].
///
/// This is a PURE function — no Dio types in the signature — so it is
/// fully unit-testable against literal fixtures, including a captured
/// real Rails HTML error page. See `docs/mobile-v1-plan.md` §4.2.
///
/// The `data is! Map` guard below is load-bearing: Rails renders
/// `ActionController::ParameterMissing` (a missing `{profile: {...}}`
/// envelope) as a 400 with an HTML body, and any unhandled exception as
/// an HTML 500. Without this guard, `data['error']` would throw
/// `_TypeError` *inside* the interceptor, surfacing as an unhandled async
/// error instead of a normal, displayable [ApiException].
ApiException mapError(int? status, Object? data) {
  if (status == null) return const NetworkFailure();

  if (data is! Map) {
    return ServerFailure(status, raw: data is String ? data : null);
  }

  final errors = data['errors'];
  if (errors is List) {
    return ValidationFailed(
      errors.map((e) => '$e').toList(growable: false),
      status,
    );
  }

  final errorField = data['error'];
  final message = errorField is String ? errorField : null;

  return switch (status) {
    401 => Unauthorized(message ?? 'Your session has expired.'),
    403 => Forbidden(message ?? 'You do not have access to that.'),
    404 => NotFound(message ?? 'Not found.'),
    429 => RateLimited(message ?? 'Too many requests. Try again shortly.'),
    >= 500 => ServerFailure(status),
    _ when message != null => RequestRejected(message, status),
    _ => Unexpected(status),
  };
}
