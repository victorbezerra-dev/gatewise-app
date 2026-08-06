import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  SecureStore._();

  static final _storage = FlutterSecureStorage();

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kIdToken = 'id_token';
  static const _kExpiresAt = 'expires_at';
  static const _kUserData = 'user_data';
  static const _kPrivateKey = 'private_key';
  static const _kPublicKey = 'public_key';

  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? idToken,
    DateTime? expiresAt,
  }) async {
    await _storage.write(key: _kAccessToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _kRefreshToken, value: refreshToken);
    }
    if (idToken != null) {
      await _storage.write(key: _kIdToken, value: idToken);
    }
    if (expiresAt != null) {
      await _storage.write(
        key: _kExpiresAt,
        value: expiresAt.millisecondsSinceEpoch.toString(),
      );
    } else {
      await _storage.delete(key: _kExpiresAt);
    }
  }

  static Future<String?> get accessToken async =>
      _storage.read(key: _kAccessToken);

  static Future<String?> get refreshToken async =>
      _storage.read(key: _kRefreshToken);

  static Future<String?> get idToken async => _storage.read(key: _kIdToken);

  static Future<DateTime?> get expiresAt async {
    final raw = await _storage.read(key: _kExpiresAt);
    if (raw == null) return null;
    final ms = int.tryParse(raw);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<void> saveUserJson(String userJson) =>
      _storage.write(key: _kUserData, value: userJson);

  static Future<String?> getUserJson() => _storage.read(key: _kUserData);

  static Future<void> clearUser() => _storage.delete(key: _kUserData);

  static Future<void> saveKeys({
    required String privateKeyPem,
    required String publicKeyPem,
  }) async {
    await _storage.write(key: _kPrivateKey, value: privateKeyPem);
    await _storage.write(key: _kPublicKey, value: publicKeyPem);
  }

  static Future<String?> get privateKey async =>
      _storage.read(key: _kPrivateKey);

  static Future<String?> get publicKey async => _storage.read(key: _kPublicKey);

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
