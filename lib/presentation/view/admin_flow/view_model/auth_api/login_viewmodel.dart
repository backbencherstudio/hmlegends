import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/token_storage.dart';
import '../../../../../core/services/user_type_storage.dart';

class LoginScreenProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _userType;

  final TokenStorage _tokenStorage = TokenStorage();
  final UserTypeStorage _userTypeStorage = UserTypeStorage();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userType => _userType;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse(ApiEndpoints.login);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Success message: ${decodeData['message']}");

        final token = decodeData['authorization']?['access_token'];
        if (token != null) {
          await _tokenStorage.saveToken(token);
        }

        final type = decodeData['type'] ?? '';
        _userType = type;
        await _userTypeStorage.saveUserType(type);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        debugPrint("Error message: ${decodeData['message']}");
        _errorMessage =
            decodeData['message'] ?? 'Login failed: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Error: $error';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadUserType() async {
    _userType = await _userTypeStorage.getUserType() ?? '';
    notifyListeners();
  }
}
