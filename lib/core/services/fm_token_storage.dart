import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenStorage {
  static const _key = "fcmToken";
  static String? _cachedToken; // in-memory cache

  Future<void> saveFcmToken(String fcmToken) async {
    _cachedToken = fcmToken; // save to memory
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, fcmToken);
  }

  Future<String?> getFcmToken() async {
    if (_cachedToken != null) return _cachedToken;

    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_key);
    return _cachedToken;
  }

  Future<void> clearFcmToken() async {
    _cachedToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
