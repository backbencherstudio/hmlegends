import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;

import '../../admin_model/invoice_status_model.dart';
import '../../admin_model/pending_userModel.dart';

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenProvider() {
    statusGet();
    getPendingUser();
  }

  final TokenStorage _tokenStorage = TokenStorage();

  InvoiceStatusModel? _invoiceStatusModel;
  InvoiceStatusModel? get invoiceStatusModel => _invoiceStatusModel;

  PendingUserModel? _pendingUserModel;
  PendingUserModel? get pendingUserModel => _pendingUserModel;

  String? loadingUserId;

  //    Get Admin Status
  Future<void> statusGet() async {
    try {
      final url = Uri.parse(ApiEndpoints.adminStatus);
      final token = await _tokenStorage.getToken();

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _invoiceStatusModel = InvoiceStatusModel.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      debugPrint("Status error: $error");
    }

    notifyListeners();
  }

  //    Fetch Pending Users
  Future<void> getPendingUser() async {
    try {
      final url = Uri.parse(ApiEndpoints.pendingUser);
      final token = await _tokenStorage.getToken();

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _pendingUserModel = PendingUserModel.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      debugPrint("Pending user error: $error");
    }

    notifyListeners();
  }

  //    Accept / Reject
  Future<void> acceptRequest(String userId, String status) async {
    loadingUserId = userId;
    notifyListeners();

    try {
      final url = Uri.parse(ApiEndpoints.acceptRequest(userId));

      debugPrint("the url is $url");
      final token = await _tokenStorage.getToken();

       final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-type": "application/json",
        },
        body: jsonEncode({"status": status}),
      );
       final decodeData = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        debugPrint("The approve or reject success ${decodeData['message']}");
      }else{
        debugPrint("The approve or reject failed ${decodeData['message']}");

      }
    } catch (error) {
      debugPrint("Accept/Reject error: $error");
    }

    loadingUserId = null;
    notifyListeners();

    // Refresh list after approval
    await getPendingUser();
  }
}
