/// A single sealed exception type covering every error shape the Rails
/// API can produce, including the ones a naive client would crash on.
///
/// See `docs/mobile-v1-plan.md` §4.2 for the three-and-a-half response
/// shapes this normalizes: `{"error": "..."}`, `{"errors": [...]}`, raw
/// HTML (unhandled Rails exceptions — there is no `rescue_from` in the
/// app today), and network-level failures.
sealed class ApiException implements Exception {
  const ApiException(this.status);

  /// The HTTP status code, or null for a failure that never reached the
  /// server (timeout, DNS, socket).
  final int? status;

  @override
  String toString() => 'ApiException(status: $status)';
}

/// The request never reached the server, or no response came back:
/// timeout, DNS failure, no connectivity, connection reset.
final class NetworkFailure extends ApiException {
  const NetworkFailure() : super(null);
}

/// 401 — the token is missing, malformed, or expired. Callers should
/// treat this as "session over": the auth interceptor already triggers
/// force-logout when this is thrown from a non-public endpoint.
final class Unauthorized extends ApiException {
  const Unauthorized(this.message) : super(401);
  final String message;
}

/// 403 — authenticated, but not allowed to do this
/// (e.g. no `ProfileAccess` to the target profile).
final class Forbidden extends ApiException {
  const Forbidden(this.message) : super(403);
  final String message;
}

/// 404.
final class NotFound extends ApiException {
  const NotFound(this.message) : super(404);
  final String message;
}

/// 422 with a Rails model-validation `{"errors": [...]}` body. Messages
/// are already human-readable full sentences ready to display.
final class ValidationFailed extends ApiException {
  const ValidationFailed(this.messages, int status) : super(status);
  final List<String> messages;

  String get firstMessage =>
      messages.isEmpty ? 'That did not work.' : messages.first;
}

/// A 4xx that isn't one of the above but carries a single `{"error": "…"}`
/// string — the OTP-flow 422s, the photo-reorder 422, and plain 400s with
/// a JSON body.
final class RequestRejected extends ApiException {
  const RequestRejected(this.message, int status) : super(status);
  final String message;
}

/// 429 — rate limited. `PhoneAuthController` is the only endpoint that
/// throttles today (5/hour/phone, 30s resend); everything else is
/// unthrottled server-side pending the Phase 1 `rack-attack` work.
final class RateLimited extends ApiException {
  const RateLimited(this.message) : super(429);
  final String message;
}

/// A 5xx, OR any status with a non-JSON (HTML) body — Rails has no
/// `rescue_from`, so `params.require` misses (400) and unhandled
/// exceptions (500) render an HTML error page instead of JSON. [raw] is
/// captured for logging only and must NEVER be shown to a user: Rails'
/// development HTML error page contains stack traces.
final class ServerFailure extends ApiException {
  const ServerFailure(super.status, {this.raw});
  final String? raw;
}

/// Anything else — a status code with a JSON body matching none of the
/// known shapes.
final class Unexpected extends ApiException {
  const Unexpected(super.status);
}
