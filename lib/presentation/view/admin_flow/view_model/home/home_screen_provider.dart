import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/network/network_service.dart';
import '../../admin_model/invoice_status_model.dart';
import '../../admin_model/order/get_last_seven_days_orders_model.dart';
import '../../admin_model/pending_userModel.dart';

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenProvider() {
    statusGet();
    getPendingUser();
    getLastSevenDaysOrders();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final TokenStorage _tokenStorage = TokenStorage();

  InvoiceStatusModel? _invoiceStatusModel;

  InvoiceStatusModel? get invoiceStatusModel => _invoiceStatusModel;

  PendingUserModel? _pendingUserModel;

  PendingUserModel? get pendingUserModel => _pendingUserModel;

  GetLastSevenDaysOrdersModel? _getLastSevenDaysOrdersModel;

  GetLastSevenDaysOrdersModel? get getLastSevenDaysOrdersModel =>
      _getLastSevenDaysOrdersModel;

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
        _invoiceStatusModel = InvoiceStatusModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (error) {
      debugPrint("Status error: $error");
    }

    notifyListeners();
  }

  /// -------------------    Fetch Pending Users ------------------------------
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

      logger.i("Pending user url: ${response.request?.url}");
      logger.i("Pending user status code: ${response.statusCode}");
      logger.i("Pending user body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _pendingUserModel = PendingUserModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (error) {
      debugPrint("Pending user error: $error");
    }

    notifyListeners();
  }

  /// --------------------    Accept / Reject Function -------------------------
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
      logger.i("Accept/Reject url: ${response.request?.url}");
      logger.i("Accept/Reject status code: ${response.statusCode}");
      logger.i("Accept/Reject body: ${response.body}");

      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.d("The approve or reject success ${decodeData['message']}");
      } else {
        logger.d("The approve or reject failed ${decodeData['message']}");
      }
    } catch (error) {
      logger.d("Accept/Reject error: $error");
    }

    loadingUserId = null;
    notifyListeners();

    // Refresh list after approval
    await getPendingUser();
  }

  /// ---------------- Function to call Get last 7 days Orders -----------------
  Future<void> getLastSevenDaysOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      final url = Uri.parse(ApiEndpoints.getLastSevenDaysOrders);
      final token = await _tokenStorage.getToken();
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-type": "application/json",
        },
      );
      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _getLastSevenDaysOrdersModel = GetLastSevenDaysOrdersModel.fromJson(
          decodeData,
        );
        // Log the data to verify
        if (_getLastSevenDaysOrdersModel?.data != null) {
          for (var item in _getLastSevenDaysOrdersModel!.data!) {
            logger.d(
              "Date: ${item.plainDate}, Quantity: ${item.totalQuantity}",
            );
          }
        }
        logger.d("The last 7 days orders success ${decodeData['message']}");
      } else {
        logger.d("The last 7 days orders failed ${decodeData['message']}");
      }
    } catch (e) {
      logger.d("The last 7 days orders error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
