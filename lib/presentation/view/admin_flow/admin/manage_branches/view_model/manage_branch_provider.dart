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

  /// --------------------- Text Field Controllers -----------------------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  /// ------------------- dispose Controller -----------------------------------

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
  }

  ///-------------------- Dropdown values --------------------------------------
  String? selectedProduct;
  String? selectedStockStatus;

  /// -------------------- Dropdown options ------------------------------------
  final List<String> stockStatusOptions = ['ACTIVE', 'LOCKED'];

  /// -------------------- Toggle Stock Status --------------------------------
  void toggleStockStatus(String? newValue) {
    selectedStockStatus = newValue;
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

  /// ---------------------------- Get All Branch ------------------------------

  Future<void> allBranch() async {
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
    }
  }

  /// ---------------------------- Update Branch ------------------------------
  Future<dynamic> updateBranch({
    required String userId,
    required String name,
    required String address,
    required String status,
    File? image,
  }) async {
    try {
      final token = await _tokenStorage.getToken();

      var url = Uri.parse(ApiEndpoints.updateBranch(userId));
      final body = jsonEncode({
        "name": name,
        "address": address,
        "status": status,
        "image": image?.path,
      });
      var response = await http.patch(
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
        logger.i("Failed to update branch: ${response.statusCode}");
        return {"success": false, "message": message};
      }
    } catch (error) {
      logger.i("The error message $error");
      return error;
    }
  }
}
