import 'package:christimony/core/network/interceptors/error_interceptor.dart';
import 'package:christimony/core/session/session.dart';
import 'package:christimony/core/session/session_controller.dart';
import 'package:christimony/core/session/token_store.dart';
import 'package:christimony/core/theme/theme.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:christimony/domain/models/account.dart';
import 'package:christimony/features/auth/otp_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

class _MemoryStore extends TokenStore {
  String? token;
  Account? account;

  @override
  Future<String?> readToken() async => token;
  @override
  Future<Account?> readAccount() async => account;
  @override
  Future<void> writeToken(String t) async => token = t;
  @override
  Future<void> writeAccount(Account a) async => account = a;
  @override
  Future<void> clear() async => token = account = null;
}

const _phone = '+919876543210';

void main() {
  late DioAdapter adapter;

  Future<ProviderContainer> pumpOtp(WidgetTester tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
      ..interceptors.add(ErrorInterceptor());
    adapter = DioAdapter(dio: dio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStoreProvider.overrideWithValue(_MemoryStore()),
          christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
        ],
        child: MaterialApp(
          theme: buildTheme(),
          home: const OtpScreen(phone: _phone),
        ),
      ),
    );
    await tester.pump();
    return ProviderScope.containerOf(tester.element(find.byType(OtpScreen)));
  }

  testWidgets('a pasted code fills every cell and submits {phone, code}', (
    tester,
  ) async {
    final container = await pumpOtp(tester);
    adapter.onPost(
      '/auth/phone/verify',
      (s) => s.reply(200, {
        'token': 'a.b.c',
        'account': {'id': 7, 'phone': _phone, 'account_type': 'individual'},
        'is_new_account': true,
        'onboarding': {'complete': false, 'profile_id': null},
      }),
      data: {'phone': _phone, 'code': '123456'},
    );

    // Pasted text with separators is reduced to its digits.
    await tester.enterText(find.byType(TextField), '123 456');
    await tester.pump();
    for (final digit in '123456'.split('')) {
      expect(find.text(digit), findsOneWidget);
    }
    await tester.pump(const Duration(milliseconds: 50));

    final session = container.read(sessionProvider);
    expect(session, isA<Authenticated>());
    expect((session as Authenticated).account.id, 7);
  });

  testWidgets('a wrong code clears the cells and shows the server message', (
    tester,
  ) async {
    await pumpOtp(tester);
    adapter.onPost(
      '/auth/phone/verify',
      (s) => s.reply(422, {'error': "That code isn't right. Try again."}),
      data: {'phone': _phone, 'code': '000000'},
    );

    await tester.enterText(find.byType(TextField), '000000');
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text("That code isn't right. Try again."), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
  });
}
