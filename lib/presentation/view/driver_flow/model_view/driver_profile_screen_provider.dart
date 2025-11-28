import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;

import '../model/check_me_driver.dart';

class DriverProfileScreenProvider extends ChangeNotifier {
  final TokenStorage _tokenStorage = TokenStorage();

  CheckMeModelDriver? _checkMeModelDriver;
  CheckMeModelDriver? get checkMeModelDriver => _checkMeModelDriver;

  bool isLoading = false;
  String? errorMessage;

  Future<void> checkMeDriver() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();

      if (token == null) {
        errorMessage = 'No token found';
        isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse(ApiEndpoints.driverCheckMe);

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _checkMeModelDriver = CheckMeModelDriver.fromJson(decodeData);

        debugPrint("The success message ${decodeData['message']}");
      } else {
        errorMessage = decodeData["message"] ?? "Something went wrong";
        debugPrint("The failed message ${decodeData['message']}");
      }
    } catch (error) {
      errorMessage = "Unexpected error: $error";
      debugPrint("The error message is $error");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateDriverProfile({
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
      final url = Uri.parse(ApiEndpoints.driverProfileUpdate);
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
