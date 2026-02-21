import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin_model/admin_checkme_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ChangePasswordProvider with ChangeNotifier {
  ChangePasswordProvider() {
    adminCheckMe();
  }

  final TokenStorage _tokenStorage = TokenStorage();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  /// ------------------ TextEditingController ---------------------------------
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool get isNewPasswordVisible => _isNewPasswordVisible;

  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  /// ------------------ Toggle Password Visibility ----------------------------
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

  /// ---------------------- AdminInfoModel ------------------------------------
  AdminInfoModel? _adminInfoModel;

  AdminInfoModel? get adminInfoModel => _adminInfoModel;

  final logger = Logger();

  /// ---------------------- Admin Check Me ------------------------------------
  Future<void> adminCheckMe() async {
    try {
      final url = Uri.parse(ApiEndpoints.adminCheckMe);

      final token = await _tokenStorage.getToken();
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      logger.i("Admin Check Me URL: $url");
      logger.i("Admin Check Me Status Code: ${response.statusCode}");
      logger.i("Admin Check Me Response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodeData = jsonDecode(response.body);
        _adminInfoModel = AdminInfoModel.fromJson(decodeData);
      } else {
        logger.e("Admin Check Me Error: ${response.statusCode}");
      }
    } catch (error) {
      logger.e("Admin Check Me Error: $error");
    }
  }

  /// -------------- Profile for Admin change password -------------------------
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.changePassword);
      final token = await _tokenStorage.getToken();
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "old_password": oldPassword,
          "new_password": newPassword,
        }
      );
      logger.i("Change Password URL: $url");
      logger.i("Change Password Status Code: ${response.statusCode}");
      logger.i("Change Password Response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        logger.e("Change Password Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      logger.e("Change Password Error: $e");
      return false;
    }
  }

  /// ---------------------- Update Admin Profile -----------------------------
  Future<bool> updateAdminProfile({
    required String firstName,
    required String lastName,
    required String occupation,
    required String dateOfBirth,
    required String phoneNumber,
    required String city,
    required String address,
    File? image,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.adminProfileUpdate);
      final token = await _tokenStorage.getToken();

      var request = http.MultipartRequest("PATCH", url);
      request.headers['Authorization'] = "Bearer $token";
      request.headers['Accept'] = "application/json";

      // Add form fields
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
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
        debugPrint("No image provided for upload.");
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Decode response
      final decodeData = jsonDecode(response.body);

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: $decodeData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Profile updated successfully.");
        return true;
      } else {
        debugPrint("Profile update failed.");
        return false;
      }
    } catch (error) {
      debugPrint("Admin Profile Update Error: $error");
      return false;
    }
  }
}
