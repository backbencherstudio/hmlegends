import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/constant/api_endpoint.dart';
import '../../../core/services/api_service.dart';

class RegisterProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _type = '';
  String get type => _type;

  String _email = '';
  String get email => _email;

  void setEmail(String email) {
    _email = email;
    debugPrint("Email: $email");
    notifyListeners();
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isConfirmPassObscured = true;
  bool get isConfirmPassObscured => _isConfirmPassObscured;

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;


  void toggleConfirmPassObscured() {
    _isConfirmPassObscured = !_isConfirmPassObscured;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  final ApiService _apiService = ApiService();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,

  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      "name": name,
      "email": email,
      "password": password,
      "type": type,
    };

    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        data: data,
      );

      debugPrint("register response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        setEmail(email);
        _isLoading = false;
        notifyListeners();
        _errorMessage = response.data['message'];
        debugPrint("register response: ${response.data['message']}");
        notifyListeners();
        if (_errorMessage.contains('Email already exist')) {
          return false;
        } else {
          return true;
        }
      } else {
        _errorMessage = response.data['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}