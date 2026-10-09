import 'api_exception.dart';

/// A sentence safe to show the user for any thrown error. Server messages
/// are already user-ready; anything unrecognised gets a generic line
/// (never a raw exception or an HTML body).
String errorText(Object error) => switch (error) {
  NetworkFailure() => "Can't reach Christimony. Check your connection.",
  ValidationFailed(:final firstMessage) => firstMessage,
  RequestRejected(:final message) => message,
  RateLimited(:final message) => message,
  Forbidden() => "You don't have access to that.",
  NotFound() => "That's no longer available.",
  Unauthorized() => 'Please sign in again.',
  _ => 'Something went wrong. Please try again.',
};
