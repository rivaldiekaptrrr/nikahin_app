import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for hardware-backed encrypted key-value storage (Keystore on Android, Keychain on iOS).
/// Used for sensitive credentials such as auth tokens, PIN codes, and biometric verification keys.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserPin = 'user_pin';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keySessionSecret = 'session_secret';

  // Generic Operations
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  // Domain-Specific Credentials
  Future<void> saveAuthToken(String token) async {
    await write(_keyAuthToken, token);
  }

  Future<String?> getAuthToken() async {
    return await read(_keyAuthToken);
  }

  Future<void> clearAuthToken() async {
    await delete(_keyAuthToken);
  }

  Future<void> setUserPin(String pin) async {
    await write(_keyUserPin, pin);
  }

  Future<String?> getUserPin() async {
    return await read(_keyUserPin);
  }

  Future<bool> validateUserPin(String enteredPin) async {
    final storedPin = await getUserPin();
    if (storedPin == null) return false;
    return storedPin == enteredPin;
  }

  Future<void> clearUserPin() async {
    await delete(_keyUserPin);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await write(_keyBiometricEnabled, enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final val = await read(_keyBiometricEnabled);
    return val == 'true';
  }

  Future<void> saveSessionSecret(String secret) async {
    await write(_keySessionSecret, secret);
  }

  Future<String?> getSessionSecret() async {
    return await read(_keySessionSecret);
  }
}

/// Global provider for SecureStorageService
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
