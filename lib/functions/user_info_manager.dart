import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserInfoManager {
  static const _kUserInfoKey = 'userInfo';
  static final _storage = const FlutterSecureStorage();

  static Future<void> save(Map<String, dynamic> info) =>
      _storage.write(key: _kUserInfoKey, value: jsonEncode(info));

  static Future<Map<String, dynamic>?> load() async {
    final raw = await _storage.read(key: _kUserInfoKey);
    if (raw == null) return null;

    final decoded = jsonDecode(raw);
    if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
    }
    return null;
  }

  static Future<void> clear() => _storage.delete(key: _kUserInfoKey);
}
