import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/models/account.dart';

/// Persists the JWT and the last-known account in platform secure storage
/// (Keychain / Keystore). The cached account lets a launch with no network
/// stay signed in instead of bouncing to login.
class TokenStore {
  TokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _accountKey = 'auth_account';

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<Account?> readAccount() async {
    final raw = await _storage.read(key: _accountKey);
    if (raw == null) return null;
    try {
      return Account.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> writeAccount(Account account) =>
      _storage.write(key: _accountKey, value: jsonEncode(account.toJson()));

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _accountKey);
  }
}

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());
