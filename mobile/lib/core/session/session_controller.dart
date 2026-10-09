import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/christimony_api.dart';
import '../../domain/models/account.dart';
import '../network/api_exception.dart';
import '../network/endpoints.dart';
import '../storage/auth_token_holder.dart';
import 'session.dart';
import 'token_store.dart';

/// The decoded response of every sign-in endpoint (phone verify, Google,
/// Apple): `{token, account, is_new_account, onboarding}`. `onboarding` is
/// a top-level sibling of `account` there, so it's merged in here to give
/// one [Account] shaped like `GET /me`'s.
class SignInResult {
  const SignInResult({
    required this.token,
    required this.account,
    required this.isNewAccount,
  });

  factory SignInResult.fromJson(Object? json) {
    final body = json! as Map<String, dynamic>;
    return SignInResult(
      token: body['token'] as String,
      account: Account.fromJson(body['account'] as Map<String, dynamic>)
          .copyWith(
            onboarding: OnboardingStatus.fromJson(
              body['onboarding'] as Map<String, dynamic>,
            ),
          ),
      isNewAccount: body['is_new_account'] == true,
    );
  }

  final String token;
  final Account account;
  final bool isNewAccount;
}

final sessionProvider = NotifierProvider<SessionController, Session>(
  SessionController.new,
);

/// The signed-in account, or null. Convenience for screens that only need
/// the account (e.g. comparing `sender_account_id` to "me").
final currentAccountProvider = Provider<Account?>((ref) {
  final session = ref.watch(sessionProvider);
  return session is Authenticated ? session.account : null;
});

/// Owns the session lifecycle: restore on launch, sign in, refresh the
/// account after onboarding changes it, and sign out. The router's redirect
/// guard reacts to [state]; nothing here navigates.
class SessionController extends Notifier<Session> {
  /// Tokens last 30 days; one older than a week is swapped on launch so an
  /// active user never hits the expiry.
  static const refreshAfter = Duration(days: 7);
  static const _tokenLifetime = Duration(days: 30);

  /// Set by push registration so logout can unregister this device.
  String? deviceToken;

  ChristimonyApi get _api => ref.read(christimonyApiProvider);
  TokenStore get _store => ref.read(tokenStoreProvider);
  AuthTokenHolder get _holder => ref.read(authTokenHolderProvider);

  @override
  Session build() {
    _holder.onUnauthenticated = () => unawaited(_clear());
    unawaited(Future.microtask(_restore));
    return const SessionLoading();
  }

  Future<void> _restore() async {
    final token = await _store.readToken();
    if (token == null) {
      state = const Unauthenticated();
      return;
    }
    _holder.token = token;

    try {
      if (_shouldRefresh(token)) await _refreshToken();
      final account = await _fetchMe();
      await _store.writeAccount(account);
      state = Authenticated(account);
    } on Unauthorized {
      await _clear();
    } on ApiException {
      // Offline or server trouble: stay signed in on the cached account
      // rather than logging out over a flaky network.
      final cached = await _store.readAccount();
      state = cached == null ? const Unauthenticated() : Authenticated(cached);
    }
  }

  Future<void> signIn(SignInResult result) async {
    _holder.token = result.token;
    await _store.writeToken(result.token);
    await _store.writeAccount(result.account);
    state = Authenticated(result.account);
  }

  /// Re-reads `/me` -- call after anything that changes onboarding status
  /// or account type, so the router guard sees the new state.
  Future<void> refreshAccount() async {
    final account = await _fetchMe();
    await _store.writeAccount(account);
    state = Authenticated(account);
  }

  Future<void> logout() async {
    try {
      await _api.send<void>(
        Api.logout,
        fields: {'device_token': ?deviceToken},
        decode: (_) {},
      );
    } on ApiException {
      // Best effort: the local session ends regardless.
    }
    await _clear();
  }

  Future<void> _clear() async {
    _holder.token = null;
    deviceToken = null;
    await _store.clear();
    state = const Unauthenticated();
  }

  Future<Account> _fetchMe() => _api.send(
    Api.me,
    decode: (json) => Account.fromJson(json! as Map<String, dynamic>),
  );

  Future<void> _refreshToken() async {
    final token = await _api.send(
      Api.refreshToken,
      decode: (json) => (json! as Map<String, dynamic>)['token'] as String,
    );
    _holder.token = token;
    await _store.writeToken(token);
  }

  static bool _shouldRefresh(String token) {
    final exp = jwtExpiry(token);
    if (exp == null) return false;
    return exp.difference(DateTime.now()) < _tokenLifetime - refreshAfter;
  }
}

/// The `exp` claim of a JWT, without verifying it (the server does that).
DateTime? jwtExpiry(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;
  try {
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    ) as Map<String, dynamic>;
    final exp = payload['exp'];
    return exp is int ? DateTime.fromMillisecondsSinceEpoch(exp * 1000) : null;
  } on Object {
    return null;
  }
}
