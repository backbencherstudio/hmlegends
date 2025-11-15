import 'package:flutter/material.dart';

import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';

class VerifyOtpViewmodel extends ChangeNotifier {
  bool _isFPLoading = false;
  bool get isFPLoading => _isFPLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _otpToken = '';
  String get otpToken => _otpToken;

  String _email = '';
  String get email => _email;

  String _tempPassword = '';
  String get tempPassword => _tempPassword;

  final ApiService _apiService = ApiService();

  Future<bool> forgetPassword({required String email}) async {
    _isFPLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.post(
        ApiEndpoints.forgetPassword,
        data: {"email": email},
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        _email = data['email'] ?? '';
        _otpToken = data['token'] ?? '';
        _tempPassword = data['password'] ?? '';
        _errorMessage = "OTP sent to $_email";

        _isFPLoading = false;
        notifyListeners();
        return true;
      } else {
        _isFPLoading = false;
        _errorMessage = response.data['message'] ?? 'Something went wrong';
        notifyListeners();
        return false;
      }
    } catch (error) {
      debugPrint('Error during forget password: $error');
      _isFPLoading = false;
      _errorMessage = 'Network error. Please check your connection.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String enteredOtp) async {
    if (enteredOtp == _otpToken) {
      _errorMessage = "OTP verified successfully";
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Invalid OTP";
      notifyListeners();
      return false;
    }
  }
}
