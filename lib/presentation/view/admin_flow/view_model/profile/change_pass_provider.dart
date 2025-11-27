import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin_model/admin_checkme_model.dart';
import 'package:http/http.dart' as http;

class ChangePasswordProvider with ChangeNotifier {
  final TokenStorage _tokenStorage = TokenStorage();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
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

  AdminInfoModel? _adminInfoModel;
  AdminInfoModel? get adminInfoModel => _adminInfoModel;

  Future<void> adminCheckMe() async {
    try {
      final url = Uri.parse(ApiEndpoints.adminCheckMe);

      final token = await _tokenStorage.getToken();
      final response = await http.get(
        headers: {"Authorization": "Bearer $token"},
        url,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodeData = jsonDecode(response.body);
        _adminInfoModel = AdminInfoModel.fromJson(decodeData);
        debugPrint("The message ${_adminInfoModel!.data!.type}");
        debugPrint("The message ${_adminInfoModel!.data!.id}");
        debugPrint("The message ${_adminInfoModel!.data!.firstName}");
        debugPrint("The message ${_adminInfoModel!.data!.lastName}");
        debugPrint("The success message ${decodeData['message']}");
        notifyListeners();
      } else {
        final decodeData = jsonDecode(response.body);
        _adminInfoModel = AdminInfoModel.fromJson(decodeData);
        debugPrint("The message ${_adminInfoModel!.data!.type}");
        debugPrint("The message ${_adminInfoModel!.data!.id}");
        debugPrint("The message ${_adminInfoModel!.data!.firstName}");
        debugPrint("The message ${_adminInfoModel!.data!.lastName}");
        debugPrint("The failed message ${decodeData['message']}");
        notifyListeners();
      }
      notifyListeners();
    } catch (error) {
      debugPrint("THe error message is $error");
    }
  }

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
