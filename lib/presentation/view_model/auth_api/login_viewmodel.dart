import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constant/api_endpoint.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/socket_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/services/user_id_storage.dart';

class LoginScreenProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final TokenStorage _tokenStorage = TokenStorage();
  // final UserIdStorage _userIdStorage = UserIdStorage();
  // final SocketService _socketService = SocketService();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  final ApiService _apiService = ApiService();
  // UserModel? _user;
  // UserModel? get user => _user;

  Future<bool> login({required String email,required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final token = data['authorization']['access_token'];
        await _tokenStorage.saveToken(token);
        debugPrint("The authorization token is $token");
        //another api call nested
        // await getMe();
        // _socketService.connect(token: token);
        // socket Check if connected
        // if (_socketService.isConnected) {
        //   debugPrint(" Socket connection successful!");
        // }
        // _socketService.emit('create_room', {'roomName': 'user_support_room'});
        _errorMessage= data['message'];
        _isLoading = false;
        notifyListeners();
        return data['success'];
      } else {
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