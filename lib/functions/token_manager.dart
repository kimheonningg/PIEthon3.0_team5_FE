import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const _kAccessTokenKey = 'accessToken';
  static final _secure = const FlutterSecureStorage();

  static Future<void> saveAccessToken(String token) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kAccessTokenKey, token);
    } else {
      await _secure.write(key: _kAccessTokenKey, value: token);
    }
  }

  static Future<String?> getAccessToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kAccessTokenKey);
    } else {
      return _secure.read(key: _kAccessTokenKey);
    }
  }

  static Future<void> clearAccessToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kAccessTokenKey);
    } else {
      await _secure.delete(key: _kAccessTokenKey);
    }
  }
}
