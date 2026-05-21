import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hmlegends/core/services/fm_token_storage.dart';
import 'package:hmlegends/core/services/user_type_storage.dart';
import 'package:hmlegends/data/model/response_model.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/network/network_service.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/token_storage.dart';

class LoginViewModel with ChangeNotifier {
  /// ------------------- API Service ------------------------------------------
  final ApiService _apiService = ApiService();

  /// ------------- PasswordVisible and RememberMe -----------------------------
  bool _passwordVisible = false;
  bool _rememberMe = false;

  bool get passwordVisible => _passwordVisible;

  bool get rememberMe => _rememberMe;

  /// -------------- Token and FcmToken Storage --------------------------------
  final TokenStorage _tokenStorage = TokenStorage();
  final FcmTokenStorage _fcmTokenStorage = FcmTokenStorage();
  final UserTypeStorage _userTypeStorage = UserTypeStorage();

  TokenStorage get tokenStorage => _tokenStorage;

  FcmTokenStorage get fcmTokenStorage => _fcmTokenStorage;

  /// ----------------- TextEditingController ----------------------------------
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// ------------- Toggle Password Visibility and Remember Me -----------------
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    logger.d("Password Visible: $_passwordVisible");
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  /// --------------- Loading State --------------------------------------------
  bool _isLoadingForGoogle = false;

  bool get isLoadingForGoogle => _isLoadingForGoogle;

  void setLoadingForGoogle(bool value) {
    _isLoadingForGoogle = value;
    notifyListeners();
  }

  bool _isLoading = false;
  String? _userType;

  bool get isLoading => _isLoading;

  String? get userType => _userType;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<ResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      var body = {"email": email, "password": password};

      logger.d("Login Access Token : ${await _tokenStorage.getToken()}");

      var res = await _apiService.postHttp(ApiEndpoints.login, data: body);

      final message = res['message'];
      if (res['success'] == true) {
        final token = res['authorization']?['access_token'];
        logger.d("============== $token ============");
        final type = res['type'];
        _userType = type;
        if (token != null) {
          debugPrint("The token is======== $token");

          await _tokenStorage.saveToken(token);
        }
        if (type != null) {
          debugPrint("The token is======== $type");

          await _userTypeStorage.saveUserType(type);
        }
        return ResponseModel(success: true, message: message);
      } else {
        return ResponseModel(success: false, message: message);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    } finally {
      _setLoading(false);
    }
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
