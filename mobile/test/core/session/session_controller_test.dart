import 'dart:convert';

import 'package:christimony/core/network/interceptors/error_interceptor.dart';
import 'package:christimony/core/session/session.dart';
import 'package:christimony/core/session/session_controller.dart';
import 'package:christimony/core/session/token_store.dart';
import 'package:christimony/core/storage/auth_token_holder.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:christimony/domain/models/account.dart';
import 'package:dio/dio.dart';
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

/// An unsigned JWT whose `exp` is [fromNow] away -- enough for the
/// client-side refresh check, which never verifies signatures.
String _jwt(Duration fromNow) {
  String part(Map<String, Object> m) =>
      base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
  final exp = DateTime.now().add(fromNow).millisecondsSinceEpoch ~/ 1000;
  return '${part({'alg': 'none'})}.${part({'exp': exp})}.sig';
}

const Map<String, Object> _me = {
  'id': 7,
  'phone': '+919876543210',
  'account_type': 'individual',
  'onboarding': {'complete': true, 'profile_id': 3},
};

void main() {
  late _MemoryStore store;
  late DioAdapter adapter;
  late ProviderContainer container;

  setUp(() {
    store = _MemoryStore();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
      ..interceptors.add(ErrorInterceptor());
    adapter = DioAdapter(dio: dio);
    container = ProviderContainer(
      overrides: [
        tokenStoreProvider.overrideWithValue(store),
        christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
      ],
    );
  });

  tearDown(() => container.dispose());

  /// Builds the controller, then lets its launch-time restore finish.
  Future<Session> settled() {
    container.read(sessionProvider);
    return pumpEventQueue().then((_) => container.read(sessionProvider));
  }

  test('no stored token -> unauthenticated', () async {
    expect(await settled(), isA<Unauthenticated>());
  });

  test('stored fresh token -> authenticated from /me, no refresh', () async {
    store.token = _jwt(const Duration(days: 29));
    adapter.onGet('/me', (s) => s.reply(200, _me));

    final session = await settled();

    expect(session, isA<Authenticated>());
    expect((session as Authenticated).account.id, 7);
    expect(container.read(authTokenHolderProvider).token, store.token);
  });

  test('token older than a week is refreshed on launch', () async {
    store.token = _jwt(const Duration(days: 20));
    final fresh = _jwt(const Duration(days: 30));
    adapter
      ..onPost('/auth/refresh', (s) => s.reply(200, {'token': fresh}))
      ..onGet('/me', (s) => s.reply(200, _me));

    expect(await settled(), isA<Authenticated>());
    expect(store.token, fresh);
  });

  test('revoked token (401) -> signed out and storage cleared', () async {
    store.token = _jwt(const Duration(days: 29));
    adapter.onGet('/me', (s) => s.reply(401, {'error': 'Unauthorized'}));

    expect(await settled(), isA<Unauthenticated>());
    expect(store.token, isNull);
  });

  test('offline launch stays signed in on the cached account', () async {
    store
      ..token = _jwt(const Duration(days: 29))
      ..account = Account.fromJson(_me);
    adapter.onGet(
      '/me',
      (s) => s.throws(
        0,
        DioException.connectionError(
          requestOptions: RequestOptions(path: '/me'),
          reason: 'offline',
        ),
      ),
    );

    expect(await settled(), isA<Authenticated>());
  });

  test('signIn merges onboarding into the account; logout clears', () async {
    await settled();
    final result = SignInResult.fromJson({
      'token': 'tok',
      'account': {'id': 7, 'account_type': 'parent'},
      'is_new_account': true,
      'onboarding': {'complete': false, 'profile_id': null},
    });
    final controller = container.read(sessionProvider.notifier);

    await controller.signIn(result);
    final session = container.read(sessionProvider) as Authenticated;
    expect(session.account.onboarding?.complete, isFalse);
    expect(store.token, 'tok');

    adapter.onDelete('/auth/session', (s) => s.reply(204, null), data: <String, Object>{});
    await controller.logout();
    expect(container.read(sessionProvider), isA<Unauthenticated>());
    expect(store.token, isNull);
  });
}
