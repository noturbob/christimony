import 'package:christimony/features/auth/phone_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a valid 10-digit Indian mobile becomes E.164', () {
    expect(phoneError('9876543210'), isNull);
    expect(indianE164('9876543210'), '+919876543210');
  });

  test('wrong length asks for 10 digits', () {
    expect(phoneError(''), 'Enter a 10-digit phone number');
    expect(phoneError('98765'), 'Enter a 10-digit phone number');
  });

  test('10 digits that are not a real Indian number are rejected', () {
    expect(indianE164('0000000000'), isNull);
    expect(phoneError('0000000000'), 'Enter a valid phone number');
  });
}
