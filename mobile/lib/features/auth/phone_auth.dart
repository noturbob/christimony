import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../core/network/endpoints.dart';
import '../../data/api/christimony_api.dart';

/// The E.164 form of a 10-digit Indian number, or null when Rails'
/// `Phonelib.parse(phone, "IN")` would reject it.
String? indianE164(String digits) {
  if (digits.length != 10) return null;
  final parsed = PhoneNumber.parse(digits, destinationCountry: IsoCode.IN);
  return parsed.isValid() ? parsed.international : null;
}

/// Why [digits] can't be sent, or null when it can.
String? phoneError(String digits) => digits.length != 10
    ? 'Enter a 10-digit phone number'
    : indianE164(digits) == null
    ? 'Enter a valid phone number'
    : null;

/// What the last `POST /auth/phone/start` said: the resend cooldown, and
/// the code itself when the server runs in development.
class PhoneStart {
  const PhoneStart({this.devCode, this.retryAfter = 30});
  final String? devCode;
  final int retryAfter;
}

final phoneStartProvider = NotifierProvider<PhoneStartController, PhoneStart>(
  PhoneStartController.new,
);

class PhoneStartController extends Notifier<PhoneStart> {
  @override
  PhoneStart build() => const PhoneStart();

  Future<void> send(String phone) async {
    state = await ref
        .read(christimonyApiProvider)
        .send(
          Api.phoneStart,
          fields: {'phone': phone},
          decode: (json) {
            final body = json! as Map<String, dynamic>;
            return PhoneStart(
              devCode: body['dev_code']?.toString(),
              retryAfter: (body['retry_after'] as num?)?.toInt() ?? 30,
            );
          },
        );
  }
}
