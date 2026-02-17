import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/manage_branch_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/single_branch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/web.dart';

class ManageBranchProvider extends ChangeNotifier {
  final _tokenStorage = TokenStorage();
  ManageBranchModel? _manageBranchModel;

  ManageBranchModel? get manageBranchModel => _manageBranchModel;
  SingleBranchModel? _singleBranchModel;
  SingleBranchModel? get singleBranchModel => _singleBranchModel;


  bool isLoading = false;

  final logger = Logger();

  Future<void> allBranch() async {
    try {
      isLoading = true;
      notifyListeners();

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
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addNewBranch({
    required String name,
    required String email,
    required String password,
    required String address,
    required String status,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

       final token = await _tokenStorage.getToken();

      var url = Uri.parse(ApiEndpoints.addNewBranch);

      var response = await http.post(
        url,
        headers: {
           "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "address": address,
          "status": status,
        }),
      );

      logger.i("Response url : ${response.request?.url}");
      logger.i("Response status code: ${response.statusCode}");
      logger.i("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Branch response: ${response.body}");
        return {"success": true, "message": "Branch added successfully"};
      } else {
        logger.i("Failed to add branch: ${response.statusCode}");
        return {
          "success": false,
          "message": "Failed to add branch: ${response.statusCode}",
        };
      }
    } catch (error) {
      logger.i("The error message $error");
      return {"success": false, "message": "Error: $error"};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSingleBranch(String userId)async{

    try{
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.singleBranch(userId));
      final response = await http.get(url,
      headers: {
        "Authorization":"bearer $token"
      });
      if(response.statusCode == 200 || response.statusCode == 201){

        final decodeData = jsonDecode(response.body);
        _singleBranchModel = SingleBranchModel.fromJson(decodeData);
      }else{

      }

    }catch(error){
      debugPrint("The errir message ${error}");
    }

  }
}
