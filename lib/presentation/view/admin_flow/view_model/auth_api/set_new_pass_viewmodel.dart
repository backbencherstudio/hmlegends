import 'package:flutter/material.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';

class SetPasswordViewModel extends ChangeNotifier {
  String? errorMessage;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  String _password = '';
  String _confirmPassword = '';

  final ApiService _apiService = ApiService();

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  bool canUpdatePassword() {
    return _password.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _password == _confirmPassword;
  }

  Future<bool> updatePassword({required String email, required String token}) async {
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        ApiEndpoints.setNewPassword,
        data: {
          "email": email,
          "token": token,
          "password": _password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        errorMessage = response.data['message'] ?? "Failed to update password";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Network error. Please try again.";
      notifyListeners();
      return false;
    }
  }
}
