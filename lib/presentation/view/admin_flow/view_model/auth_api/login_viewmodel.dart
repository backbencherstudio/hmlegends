import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/token_storage.dart';
import '../../../../../core/services/user_type_storage.dart';

class LoginScreenProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final UserTypeStorage _userTypeStorage = UserTypeStorage();
  // final SocketService _socketService = SocketService();
  final TokenStorage _tokenStorage = TokenStorage();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  final ApiService _apiService = ApiService();
  // UserModel? _user;
  // UserModel? get user => _user;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final url = Uri.parse(ApiEndpoints.login);

      final token = await _tokenStorage.getToken();
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodeData = jsonDecode(response.body);
        debugPrint("The success message ${decodeData['message']}");
        await _tokenStorage.saveToken(
          decodeData['authorization']['access_token'],
        );
        await _userTypeStorage.saveUserType(decodeData['type']);
        debugPrint("The user Type is ${decodeData['type']}");
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final decodeData = jsonDecode(response.body);
        debugPrint("The success message ${decodeData['message']}");
        _isLoading = false;
        _errorMessage = 'Login failed: ${response.statusCode}';
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
}
