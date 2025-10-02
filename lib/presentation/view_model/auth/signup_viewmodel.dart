import 'package:flutter/foundation.dart';

class SignUpViewModel with ChangeNotifier {
  bool _passwordVisible = false;

  // Getters
  bool get passwordVisible => _passwordVisible;

  // Methods to update state
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }
}
