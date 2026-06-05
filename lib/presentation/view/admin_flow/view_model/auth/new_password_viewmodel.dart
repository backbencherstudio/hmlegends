import 'package:flutter/foundation.dart';

class SetNewPasswordViewModel with ChangeNotifier {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _password = '';
  String _confirmPassword = '';
  String? _errorMessage;

  // Getters
  bool get passwordVisible => _passwordVisible;
  bool get confirmPasswordVisible => _confirmPasswordVisible;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String? get errorMessage => _errorMessage;

  // Methods to update state
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _validatePasswords();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _validatePasswords();
  }

  void _validatePasswords() {
    if (_confirmPassword.isNotEmpty && _password != _confirmPassword) {
      _errorMessage = 'Passwords don\'t match';
    } else {
      _errorMessage = null;
    }
    notifyListeners();
  }

  bool canUpdatePassword() {
    return _password.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _password == _confirmPassword;
  }

  void clearFields() {
    _password = '';
    _confirmPassword = '';
    _errorMessage = null;
    notifyListeners();
  }
}