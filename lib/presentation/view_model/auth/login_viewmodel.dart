
import 'package:flutter/foundation.dart';

class LoginViewModel with ChangeNotifier {
  bool _passwordVisible = false;
  bool _rememberMe = false;

  // Getters
  bool get passwordVisible => _passwordVisible;
  bool get rememberMe => _rememberMe;

  // Methods to update state
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }
}