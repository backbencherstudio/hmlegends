import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/api_service.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/data/model/response_model.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/profile/model/manager_info_model.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class ManagerProfileProvider with ChangeNotifier {
  ManagerProfileProvider() {
    managerCheckMe();
  }

  /// ------------------- ApiService -------------------------------------------
  final _apiService = ApiService();

  final TokenStorage _tokenStorage = TokenStorage();
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  /// ------------------ TextEditingController ---------------------------------
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;

  bool get isNewPasswordVisible => _isNewPasswordVisible;

  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  /// ------------------ Toggle Password Visibility ----------------------------
  void toggleCurrentPasswordVisibility(bool value) {
    _isCurrentPasswordVisible = value;
    notifyListeners();
  }

  void toggleNewPasswordVisibility(bool value) {
    _isNewPasswordVisible = value;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility(bool value) {
    _isConfirmPasswordVisible = value;
    notifyListeners();
  }

  /// ------------------------ Loading State -----------------------------------
  // bool _isLoading = false;
  //
  // bool get isLoading => _isLoading;
  //
  // void _setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }

  /// ------------------------ Dispose Controllers -----------------------------
  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// ---------------------- ManagerInfoModel ------------------------------------
  ManagerInfoModel? _managerInfoModel;

  ManagerInfoModel? get managerInfoModel => _managerInfoModel;

  final logger = Logger();

  final bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// ---------------------- Manager Check Me ------------------------------------
  Future<ResponseModel> managerCheckMe() async {
    try {
      final token = await _tokenStorage.getToken();

      // Check if token exists before making the request
      if (token == null || token.isEmpty) {
        logger.w("Manager Check Me: No token found");
        return ResponseModel(
          success: false,
          message: 'No authentication token found',
        );
      }

      final response = await _apiService.get(
        ApiEndpoints.managerPersonalProfile,
      );

      if (response['success'] == true) {
        _managerInfoModel = ManagerInfoModel.fromJson(response);
        notifyListeners();
        return ResponseModel(
          success: true,
          message: response['message'] ?? 'Manager info fetched successfully',
        );
      } else {
        logger.e("Manager Check Me Error: $response");
        notifyListeners();
        return ResponseModel(
          success: false,
          message: response['message'] ?? 'Failed to fetch manager info',
        );
      }
    } catch (error) {
      logger.e("Manager Check Me Error: $error");
      notifyListeners();
      return ResponseModel(success: false, message: '$error');
    }
  }

  /// -------------- Profile for Manager change password -------------------------
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.managerChangePassword);
      final token = await _tokenStorage.getToken();
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {"old_password": oldPassword, "new_password": newPassword},
      );
      logger.i("Change Password URL: $url");
      logger.i("Change Password Status Code: ${response.statusCode}");
      logger.i("Change Password Response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        notifyListeners();
        logger.i("Password changed successfully.");
        return true;
      } else {
        logger.e("Change Password Error: ${response.statusCode}");
        notifyListeners();
        return false;
      }
    } catch (e) {
      logger.e("Change Password Error: $e");
      notifyListeners();
      return false;
    }
  }

  /// ---------------------- Update Manager Profile -----------------------------
  Future<bool> updateManagerProfile({
    required String name,
    required String occupation,
    required String dateOfBirth,
    required String phoneNumber,
    required String city,
    required String address,
    File? image,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.updateManagerProfile);
      final token = await _tokenStorage.getToken();

      var request = http.MultipartRequest("PATCH", url);
      request.headers['Authorization'] = "Bearer $token";
      request.headers['Accept'] = "application/json";

      // Add form fields
      request.fields['name'] = name;
      request.fields['occupation'] = occupation;
      request.fields['date_of_birth'] = dateOfBirth;
      request.fields['phone_number'] = phoneNumber;
      request.fields['city'] = city;
      request.fields['address'] = address;

      // Add image file if provided
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      } else {
        logger.d("No image provided for upload.");
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      logger.i("STATUS: ${response.statusCode}");
      logger.i("RESPONSE BODY: ${response.body}");

      // Decode response only if we have valid JSON
      try {
        final decodeData = jsonDecode(response.body);
        logger.i("DECODED RESPONSE: $decodeData");
      } catch (e) {
        logger.e("Failed to decode response: $e");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Profile updated successfully.");
        notifyListeners();
        return true;
      } else {
        logger.e("Profile update failed with status code: ${response.statusCode}");
        logger.e("Response: ${response.body}");
        notifyListeners();
        return false;
      }
    } catch (error) {
      logger.e("Manager Profile Update Error: $error");
      notifyListeners();
      return false;
    }
  }
}
