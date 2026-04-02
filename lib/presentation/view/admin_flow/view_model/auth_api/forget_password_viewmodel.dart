import 'package:flutter/material.dart';
import 'package:hmlegends/core/network/network_service.dart';
import 'package:hmlegends/data/model/response_model.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  bool _isFPLoading = false;

  bool get isFPLoading => _isFPLoading;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  String _otpToken = '';

  String get otpToken => _otpToken;

  void setOtpToken(String token) {
    _otpToken = token;
    notifyListeners();
  }

  String _email = '';

  String get email => _email;

  void setEmail(String email) {
    _email = email;

    debugPrint("Email set successfully $email");
    notifyListeners();
  }

  final ApiService _apiService = ApiService();

  Future<ResponseModel> forgetPassword({required String email}) async {
    _isFPLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.postHttp(
        ApiEndpoints.forgetPassword,
        data: {"email": email},
      );

      if (response['success']) {
        notifyListeners();
        return ResponseModel(success: true, message: response['message']);
      } else {
        notifyListeners();
        return ResponseModel(success: false, message: response['message']);
      }
    } catch (error) {
      logger.e('Error during forget password: $error');
      notifyListeners();
      return ResponseModel(success: false, message: '$error');
    } finally {
      _isFPLoading = false;
      notifyListeners();
    }
  }

  Future<ResponseModel> otpVerify({required String otp}) async {
    _isFPLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.postHttp(
        ApiEndpoints.verifyOtpOnly,
        data: {"email": _email, "token": otp},
      );

      if (response['success']) {
        notifyListeners();
        return ResponseModel(success: true, message: response['message']);
      } else {
        notifyListeners();
        return ResponseModel(success: false, message: response['message']);
      }
    } catch (error) {
      logger.e('Error during forget password: $error');
      notifyListeners();
      return ResponseModel(success: false, message: '$error');
    }
  }

  Future<bool> setPassword({required String password}) async {
    _isFPLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.postHttp(
        ApiEndpoints.setNewPassword,
        data: {"email": _email, "token": _otpToken, "password": password},
      );
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("THe message $_email $password $_otpToken");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isFPLoading = false;

        debugPrint("The success");
        _errorMessage = response.data['message'];
        notifyListeners();
        return response.data['success'];
      } else {
        debugPrint("The failed");

        _isFPLoading = false;
        _errorMessage = response.data['message'];
        notifyListeners();
        return false;
      }
    } catch (error) {
      print('Error during forget password: $error');
      _isFPLoading = false;
      notifyListeners();
      return false;
    }
  }
}
