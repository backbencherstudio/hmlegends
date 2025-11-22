import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/token_storage.dart';

class LoginViewModel with ChangeNotifier {
  bool _passwordVisible = false;
  bool _rememberMe = false;
  final TokenStorage _tokenStorage = TokenStorage();

  bool get passwordVisible => _passwordVisible;
  bool get rememberMe => _rememberMe;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  bool _isLoadingForGoogle = false;
  bool get isLoadingForGoogle => _isLoadingForGoogle;

  void setLoadingForGoogle(bool value) {
    _isLoadingForGoogle = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> googleSignIn({String? firebaseToken}) async {
    if (firebaseToken == null) {
      debugPrint("message Firebase token is null.");
      return {"success": false, "message": "Firebase token is null."};
    }

    debugPrint("message Firebase token is $firebaseToken");
    final url = Uri.parse(ApiEndpoints.googleLogin);

    debugPrint("message Firebase token is $firebaseToken.");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": firebaseToken, 'type': "admin"}),
      );

      debugPrint("response data is======== ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // debugPrint("User Id: ${data['user']['_id']}");
        debugPrint("Access Token: ${data['authorization']['access_token']}");
        debugPrint("refresh Token: ${data['authorization']['refresh_token']}");
        await _tokenStorage.saveToken(data['authorization']['access_token']);

        debugPrint("data: $data");
        debugPrint("Login success");
        return {"success": true, "data": ""};
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {"success": false, "message": "Login failed. Please try again."};
      }
    } catch (error) {
      debugPrint("Error message:======== $error");
      return {"success": false, "message": "Login failed: $error"};
    } finally {
      notifyListeners();
    }
  }
}
