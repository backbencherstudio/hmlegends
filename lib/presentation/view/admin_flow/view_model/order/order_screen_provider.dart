import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import '../../admin_model/order/admin_singl_order_model.dart';
import '../../admin_model/order/order_admin_model.dart';

class OrderScreenProvider extends ChangeNotifier {
  OrderScreenProvider() {
    getAdminOrder();
  }

  final TokenStorage _tokenStorage = TokenStorage();

  ///--------------------------- Loading State -------------------------------
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ///---------------------------- Order Data -----------------------------------
  OrderAdminModel? _orderAdminModel;

  OrderAdminModel? get orderAdminModel => _orderAdminModel;

  final logger = Logger();

  int _selectedFilterOrder = 0;

  int get selectedFilterOrder => _selectedFilterOrder;

  void setSelectedFilterOrder(int index) {
    _selectedFilterOrder = index;
    notifyListeners();
  }

  String _selectedPeriod = 'week';

  String get selectedPeriod => _selectedPeriod;

  void setSelectedPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  /// --------------------- fetch Admin Order ---------------------------------
  Future<void> getAdminOrder() async {
    try {
      final token = await _tokenStorage.getToken();

      final url = Uri.parse(
        ApiEndpoints.adminOrder,
      ).replace(queryParameters: {"period": selectedPeriod});

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      logger.i("Request URL: $url");
      logger.i("Status Code: ${response.statusCode}");

      final decodeData = jsonDecode(response.body);
      logger.i("Response body: $decodeData");
      if (response.statusCode == 200 || response.statusCode == 201) {
        _orderAdminModel = OrderAdminModel.fromJson(decodeData);
        notifyListeners();
        logger.i("message:  ${decodeData['message']}");
      } else {
        logger.i("Failed: ${decodeData['message']}");
        notifyListeners();
      }
    } catch (error) {
      logger.e("Error fetching admin orders: $error");
      notifyListeners();
    }
  }

  /// --------------------- fetch Single Order ---------------------------------
  AdminSingleOrderModel? _adminSingleOrderModel;

  AdminSingleOrderModel? get adminSingleOrderModel => _adminSingleOrderModel;

  Future<void> adminSingleOrder(String orderId) async {
    try {
      final token = await _tokenStorage.getToken();

      final url = Uri.parse(ApiEndpoints.adminSingleOrder(orderId));

      logger.i("Request URL: $url");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      logger.i("Request URL: $url");
      logger.i("Status Code: ${response.statusCode}");
      logger.i("Response Body: ${response.body}");
      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _adminSingleOrderModel = AdminSingleOrderModel.fromJson(decodeData);
        logger.i("success: ${decodeData['message']}");
      } else {
        logger.i("Failed: ${decodeData['message']}");
      }
    } catch (error) {
      logger.e("Error fetching single order: $error");
    }
  }

  ///----------------------- Approve Order --------------------------------
  Future<void> approveOrder(String orderId) async {
    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.orderAccept(orderId));

      logger.i("PATCH Request URL: $url");

      final response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      logger.i("Status Code: ${response.statusCode}");
      logger.i("Response Body: ${response.body}");
      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Order Approved Successfully: ${decodeData['message']}");
        await getAdminOrder();
      } else {
        logger.i("Order Approval Failed: ${decodeData['message']}");
      }
    } catch (error) {
      logger.e("Approve Order Error: $error");
    }
  }
}
