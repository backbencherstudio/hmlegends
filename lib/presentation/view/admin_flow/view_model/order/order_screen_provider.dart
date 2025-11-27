import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;
import '../../admin_model/order/order_admin_model.dart';

class OrderScreenProvider extends ChangeNotifier {
  OrderScreenProvider() {
    getAdminOrder();
  }

  final TokenStorage _tokenStorage = TokenStorage();

  // ---------------- Loading State ----------------
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ---------------- Order Data ----------------
  OrderAdminModel? _orderAdminModel;
  OrderAdminModel? get orderAdminModel => _orderAdminModel;

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
          "Accept": "application/json",
        },
      );

      debugPrint("Request URL: $url");
      debugPrint("Status Code: ${response.statusCode}");

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _orderAdminModel = OrderAdminModel.fromJson(decodeData);
        debugPrint("Success: ${decodeData['message']}");
      } else {
        debugPrint("Failed: ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("Error fetching admin orders: $error");
    } finally {
      _setLoading(false); // stop loading
    }
  }
}
