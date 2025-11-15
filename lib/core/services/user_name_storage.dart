import 'package:shared_preferences/shared_preferences.dart';

class UserNameStorage {
  static const _key = "userName";

  // Save the user's name
  Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, userName); // Save user name with the key 'userName'
  }

  // Get the user's name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key); // Retrieve user name from SharedPreferences
  }

  // Clear the stored user name
  Future<void> clearUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key); // Remove the user name from SharedPreferences
  }
}