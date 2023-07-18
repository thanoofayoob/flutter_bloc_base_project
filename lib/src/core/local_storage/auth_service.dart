// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage extends ChangeNotifier {
  bool _loginState = false;
  bool _initialized = false;
  bool _onboarding = false;

  set loginState(bool state) {
    _loginState = state;
    notifyListeners();
  }

  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  set onboarding(bool value) {
    _onboarding = value;
    notifyListeners();
  }

  bool get loginState => _loginState;
  bool get initialized => _initialized;
  bool get onboarding => _onboarding;
  static SecureStorage? _instance;

  factory SecureStorage() =>
      _instance ??= SecureStorage._(const FlutterSecureStorage());

  SecureStorage._(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'TOKEN';
  static const _emailKey = 'EMAIL';

  Future<void> onAppStart() async {
    // _onboarding = sharedPreferences.getBool(ONBOARD_KEY) ?? false;
    // _loginState = sharedPreferences.getBool(LOGIN_KEY) ?? false;

    // This is just to demonstrate the splash screen is working.
    // In real-life applications, it is not recommended to interrupt the user experience by doing such things.
    await Future.delayed(const Duration(seconds: 2));

    _initialized = true;
  }

  Future<void> persistEmailAndToken(String email, String token) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<bool> hasToken() async {
    var value = await _storage.read(key: _tokenKey);
    return value != null;
  }

  Future<bool> hasEmail() async {
    var value = _storage.read(key: _emailKey);
    return value != null;
  }

  Future<void> deleteToken() async {
    return _storage.delete(key: _tokenKey);
  }

  Future<void> deleteEmail() async {
    return _storage.delete(key: _emailKey);
  }

  Future<String?> getEmail() async {
    return _storage.read(key: _emailKey);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }
}
