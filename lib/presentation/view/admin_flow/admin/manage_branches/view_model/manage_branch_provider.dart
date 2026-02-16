import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/manage_branch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageBranchProvider extends ChangeNotifier {
  final TokenStorage _tokenStorage = TokenStorage();
  ManageBranchModel? _manageBranchModel;
  ManageBranchModel? get manageBranchModel => _manageBranchModel;
  bool isLoading = false;

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
}
