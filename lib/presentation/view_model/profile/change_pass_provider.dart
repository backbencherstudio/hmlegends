import 'package:flutter/material.dart';

class ChangePasswordProvider with ChangeNotifier {
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController =
  TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void toggleNewPasswordVisibility(bool value) {
    _isNewPasswordVisible = value;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility(bool value) {
    _isConfirmPasswordVisible = value;
    notifyListeners();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}