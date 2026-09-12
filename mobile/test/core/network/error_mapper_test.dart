import 'package:christimony/core/network/api_exception.dart';
import 'package:christimony/core/network/error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapError', () {
    test('null status maps to NetworkFailure', () {
      expect(mapError(null, null), isA<NetworkFailure>());
    });

    test('{"error": "..."} maps by status code', () {
      final result = mapError(401, {'error': 'Unauthorized'});
      expect(result, isA<Unauthorized>());
      expect((result as Unauthorized).message, 'Unauthorized');
    });

    test('403 with error body maps to Forbidden', () {
      final result = mapError(403, {'error': 'Forbidden'});
      expect(result, isA<Forbidden>());
      expect((result as Forbidden).message, 'Forbidden');
    });

    test('404 with error body maps to NotFound', () {
      final result = mapError(404, {'error': 'Profile not found'});
      expect(result, isA<NotFound>());
      expect((result as NotFound).message, 'Profile not found');
    });

    test('429 with error body maps to RateLimited', () {
      final result = mapError(429, {
        'error': 'Too many requests. Try again later.',
      });
      expect(result, isA<RateLimited>());
    });

    test('{"errors": [...]} model validation maps to ValidationFailed', () {
      final result = mapError(422, {
        'errors': ["Name can't be blank", 'Dob is invalid'],
      });
      expect(result, isA<ValidationFailed>());
      final failed = result as ValidationFailed;
      expect(failed.messages, ["Name can't be blank", 'Dob is invalid']);
      expect(failed.firstMessage, "Name can't be blank");
    });

    test('empty errors array falls back to a default message', () {
      final result = mapError(422, {'errors': <String>[]});
      expect((result as ValidationFailed).firstMessage, 'That did not work.');
    });

    test('a 422 with only {"error": "..."} maps to RequestRejected', () {
      // This is the OTP-flow shape and the photo-reorder 422 -- a single
      // string, not the model-validation array shape.
      final result = mapError(422, {
        'error': "That code isn't right. Try again.",
      });
      expect(result, isA<RequestRejected>());
      expect(
        (result as RequestRejected).message,
        "That code isn't right. Try again.",
      );
    });

    test('5xx with a JSON body still maps to ServerFailure', () {
      final result = mapError(500, {'error': 'Internal Server Error'});
      expect(result, isA<ServerFailure>());
      expect((result as ServerFailure).status, 500);
    });

    // THE load-bearing case: Rails has no rescue_from, so
    // ActionController::ParameterMissing (a missing `{profile: {...}}`
    // envelope) renders as an HTML 400, and any unhandled exception
    // renders an HTML 500. Without the `data is! Map` guard in
    // mapError, `data['error']` would throw _TypeError here.
    test('a raw HTML 400 body never throws and maps to ServerFailure', () {
      const htmlBody = '''
<!DOCTYPE html>
<html>
<head><title>Action Controller: Exception caught</title></head>
<body>
  <p>ParameterMissing: param is missing or the value is empty: profile</p>
</body>
</html>
''';
      final result = mapError(400, htmlBody);
      expect(result, isA<ServerFailure>());
      expect((result as ServerFailure).status, 400);
      expect(result.raw, htmlBody);
    });

    test('a raw HTML 500 body never throws and maps to ServerFailure', () {
      const htmlBody =
          "<html><body>We're sorry, but something went wrong.</body></html>";
      final result = mapError(500, htmlBody);
      expect(result, isA<ServerFailure>());
      // The raw HTML must never be surfaced as a user-facing message --
      // it can contain stack traces in a development environment.
      expect(result.status, 500);
    });

    test('null body with a status code maps without throwing', () {
      final result = mapError(500, null);
      expect(result, isA<ServerFailure>());
    });

    test('a JSON body matching no known shape maps to Unexpected', () {
      final result = mapError(418, {'teapot': true});
      expect(result, isA<Unexpected>());
      expect(result.status, 418);
    });

    test('a list body (not a Map) never throws', () {
      final result = mapError(500, ['unexpected', 'array']);
      expect(result, isA<ServerFailure>());
    });
  });
}
