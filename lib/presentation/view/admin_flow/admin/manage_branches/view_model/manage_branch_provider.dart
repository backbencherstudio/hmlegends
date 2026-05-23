import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/manage_branch_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/single_branch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/web.dart';

class ManageBranchProvider extends ChangeNotifier {
  ManageBranchProvider() {
    allBranch();
    notifyListeners();
  }


  // Image selection variables
  File? _selectedImageFile;
  String? _imageFormat;
  String? _imageSize;

  File? get selectedImageFile => _selectedImageFile;
  String? get imageFormat => _imageFormat;
  String? get imageSize => _imageSize;

  void setSelectedImageFile(File? value) {
    _selectedImageFile = value;
    notifyListeners();
  }

  void setImageFormat(String? value) {
    _imageFormat = value;
    notifyListeners();
  }

  void setImageSize(String? value) {
    _imageSize = value;
    notifyListeners();
  }


  ///-------------------- Dropdown values --------------------------------------
  String? selectedProduct;
  String? _selectedStockStatus;
  String? get selectedStockStatus => _selectedStockStatus;


  /// -------------------- Dropdown options ------------------------------------
  final List<String> stockStatusOptions = ['ACTIVE', 'LOCKED'];

  /// -------------------- Toggle Stock Status --------------------------------
  void toggleStockStatus(String? newValue) {
    _selectedStockStatus = newValue;
    notifyListeners();
  }

  final _tokenStorage = TokenStorage();

  /// ---------------- Manager Branch Model ------------------------------------
  ManageBranchModel? _manageBranchModel;

  ManageBranchModel? get manageBranchModel => _manageBranchModel;

  /// ---------------- Single Branch Model -------------------------------------
  SingleBranchModel? _singleBranchModel;

  SingleBranchModel? get singleBranchModel => _singleBranchModel;

  bool isLoading = false;

  final logger = Logger();

  int _selectedBranchFilter = 0; // 0: All, 1: Active, 2: Locked
  int get selectedBranchFilter => _selectedBranchFilter;

  void setSelectedBranchFilter(int index) {
    _selectedBranchFilter = index;
    notifyListeners();
  }

  /// ---------------------------- Query ---------------------------------------
  String _query = '';

  String get query => _query;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  /// ---------------------------- Get All Branch ------------------------------

  Future<void> allBranch({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
      notifyListeners();
    }
    try {
      final token = await _tokenStorage.getToken();

      final url = Uri.parse(ApiEndpoints.allBranch);

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _manageBranchModel = ManageBranchModel.fromJson(data);
        debugPrint(
          "The response model data is ${_manageBranchModel?.data?.managers![0].address}",
        );
      } else {
        debugPrint("Failed: ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("Error: $error");
    } finally {
      if (showLoading) {
        isLoading = false;
      }
      notifyListeners();
    }
  }

  /// ---------------------------- Post Add New Branch -------------------------

  Future<dynamic> addNewBranch({
    required String name,
    required String email,
    required String password,
    required String address,
    required String status,
  }) async {
    try {
      final token = await _tokenStorage.getToken();

      var url = Uri.parse(ApiEndpoints.addNewBranch);
      final body = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "address": address,
        "status": status,
      });
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      logger.d("The body data is $body");
      logger.i("Response url : ${response.request?.url}");
      logger.i("Response status code: ${response.statusCode}");
      logger.i("Response body: ${response.body}");
      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = decodeData['message'];
        logger.d("The success message ${decodeData['message']}");
        return {"success": true, "message": message};
      } else {
        final message = decodeData['message'];
        logger.i("Failed to add branch: ${response.statusCode}");
        return {"success": false, "message": message};
      }
    } catch (error) {
      logger.i("The error message $error");
      return error;
    }
  }

  /// ---------------------------- Get Single Branch ---------------------------

  Future<void> getSingleBranch(String userId, {String period = 'week'}) async {
    isLoading = true;
    notifyListeners();
    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.singleBranch(userId, period: period));
      final response = await http.get(
        url,
        headers: {"Authorization": "bearer $token"},
      );
      logger.i("Response url : ${response.request?.url}");
      logger.i("Response status code: ${response.statusCode}");
      logger.i("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodeData = jsonDecode(response.body);
        logger.d("The success message ${decodeData['message']}");
        _singleBranchModel = SingleBranchModel.fromJson(decodeData);
      } else {
        logger.d("The error message ${response.statusCode}");
      }
    } catch (error) {
      logger.i("The error message $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ---------------------------- Update Branch ------------------------------
  Future<dynamic> updateBranch({
    required String managerId,
    required String name,
    required String address,
    required String status,
    File? image,
  }) async {
    try {
      final token = await _tokenStorage.getToken();
      var url = Uri.parse(ApiEndpoints.updateBranch(managerId));

      var request = http.MultipartRequest("PATCH", url);
      request.headers['Authorization'] = "Bearer $token";
      request.headers['Accept'] = "application/json";

      // Add form fields
      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['status'] = status;

      // Add image file if provided
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      logger.d("Updating branch with fields: ${request.fields} and image: ${image?.path}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      logger.i("Response url : ${url}");
      logger.i("Response status code: ${response.statusCode}");
      logger.i("Response body: ${response.body}");

      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = decodeData['message'];
        logger.d("The success message ${decodeData['message']}");
        
        // Clear selected image and details in provider upon successful update
        _selectedImageFile = null;
        _imageFormat = null;
        _imageSize = null;

        // Fetch single branch and all branches to ensure consistency
        await getSingleBranch(managerId);
        await allBranch();

        notifyListeners();
        return {"success": true, "message": message};
      } else {
        final message = decodeData['message'];
        logger.i("Failed to update branch: ${response.statusCode}");
        return {"success": false, "message": message};
      }
    } catch (error) {
      logger.i("The error message $error");
      return {"success": false, "message": error.toString()};
    }
  }

  /// ---------------------------- Toggle Branch Status ------------------------
  Future<dynamic> toggleBranch(String userId) async {
    try {
      final token = await _tokenStorage.getToken();
      var url = Uri.parse(ApiEndpoints.toggleBranchStatus(userId));

      var response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      logger.i("Response url : $url");
      logger.i("Response status code: ${response.statusCode}");
      logger.i("Response body: ${response.body}");

      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = decodeData['message'];
        logger.d("The success message ${decodeData['message']}");
        
        // Refresh the branches list in the background
        await allBranch(showLoading: false);
        
        return {"success": true, "message": message};
      } else {
        final message = decodeData['message'];
        logger.i("Failed to toggle branch status: ${response.statusCode}");
        return {"success": false, "message": message};
      }
    } catch (error) {
      logger.i("The error message $error");
      return {"success": false, "message": error.toString()};
    }
  }
}
