import 'package:shared_preferences/shared_preferences.dart';

class UserTypeStorage {
  static const _key = "userType";

  Future<void> saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, userType); // Save the token
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key); // Retrieve the token
  }

  Future<void> clearUserType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key); // Clear the token
  }
}
