import 'package:flutter/material.dart';
import 'package:hmlegends/data/model/response_model.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/network/network_service.dart';
import '../../../../../core/services/api_service.dart';

class RegisterProvider extends ChangeNotifier {
  /// ------------------- API Service ------------------------------------------
  final ApiService _apiService = ApiService();

  /// ---------------- TextEditingController -----------------------------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  /// --------------- Loading State --------------------------------------------
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final String _type = '';

  String get type => _type;

  String _email = '';

  String get email => _email;

  void setEmail(String email) {
    _email = email;
    debugPrint("Email: $email");
    notifyListeners();
  }

  /// ------------------ Function to toggle password visibility ----------------

  bool _passwordVisible = false;

  bool get passwordVisible => _passwordVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  /// ------------------ Function to register user -----------------------------
  Future<ResponseModel> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      var data = {
        "name": name,
        "email": email,
        "password": password,
        "type": "admin",
      };
      var response = await _apiService.postHttp(
        ApiEndpoints.register,
        data: data,
      );

      final decodedData = response.data;
      final message = decodedData['message'];

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel(success: true, message: message);
      } else {
        return ResponseModel(success: false, message: message);
      }
    } catch (e) {
      logger.e("Register Error: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
