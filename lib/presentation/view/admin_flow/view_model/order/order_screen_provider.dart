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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ---------------- Order Data ----------------
  OrderAdminModel? _orderAdminModel;
  OrderAdminModel? get orderAdminModel => _orderAdminModel;

  final logger = Logger();

  Future<void> getAdminOrder() async {
    _setLoading(true); // start loading
    try {
      final token = await _tokenStorage.getToken();

      final url = Uri.parse(
        ApiEndpoints.adminOrder,
      ).replace(queryParameters: {"period": "month"});

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
      logger.i("Response Body: $decodeData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _orderAdminModel = OrderAdminModel.fromJson(decodeData);
        logger.i("message:  ${decodeData['message']}");
      } else {
        logger.i("Failed: ${decodeData['message']}");
      }
    } catch (error) {
      logger.e("Error fetching admin orders: $error");
    } finally {
      _setLoading(false); // stop loading
    }
  }

  /// --------------------- fetch Single Order ---------------------------------
  AdminSingleOrderModel? _adminSingleOrderModel;
  AdminSingleOrderModel? get adminSingleOrderModel => _adminSingleOrderModel;

  Future<void> adminSingleOrder(String orderId) async {
    try {
      _setLoading(true);
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
    } finally {
      _setLoading(false);
    }
  }

  ///----------------------- Approve Order --------------------------------
  Future<void> approveOrder(String orderId) async {
    try {
      _setLoading(true);
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

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Order Approved Successfully: ${decodeData['message']}");
      } else {
        logger.i("Order Approval Failed: ${decodeData['message']}");
      }
    } catch (error) {
      logger.e("Approve Order Error: $error");
    } finally {
      _setLoading(false);
    }
  }
}
