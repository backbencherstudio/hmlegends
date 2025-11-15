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
        debugPrint("The message ${_adminInfoModel!.data!.id}");
        debugPrint("The success message ${decodeData['message']}");
      } else {
        final decodeData = jsonDecode(response.body);
        _adminInfoModel = AdminInfoModel.fromJson(decodeData);
        debugPrint("The message ${_adminInfoModel!.data!.id}");
        debugPrint("The failed message ${decodeData['message']}");
      }
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

      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['occupation'] = occupation;
      request.fields['date_of_birth'] = dateOfBirth;
      request.fields['phone_number'] = phoneNumber;
      request.fields['city'] = city;
      request.fields['address'] = address;
      Future<bool> updateAdminProfile({
        required String firstName,
        required String lastName,
        required String occupation,
        required String dateOfBirth,
        required String phoneNumber,
        required String city,
        required String address,
        File? image, // Use File type for image
      }) async {
        try {
          final url = Uri.parse(ApiEndpoints.adminProfileUpdate);
          final token = await _tokenStorage.getToken();

          var request = http.MultipartRequest("PATCH", url);

          request.headers['Authorization'] = "Bearer $token";
          request.headers['Accept'] = "application/json";

          request.fields['first_name'] = firstName;
          request.fields['last_name'] = lastName;
          request.fields['occupation'] = occupation;
          request.fields['date_of_birth'] = dateOfBirth;
          request.fields['phone_number'] = phoneNumber;
          request.fields['city'] = city;
          request.fields['address'] = address;

          if (image != null) {
            request.files.add(
              await http.MultipartFile.fromPath('image', image.path),
            );
          }
          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          debugPrint("STATUS: ${response.statusCode}");
          debugPrint("RESPONSE: ${response.body}");

          if (response.statusCode == 200 || response.statusCode == 201) {
            return true;
          }

          return false;
        } catch (error) {
          debugPrint("Admin Profile Update Error: $error");
          return false;
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (error) {
      debugPrint("Admin Profile Update Error: $error");
      return false;
    }
  }
}
