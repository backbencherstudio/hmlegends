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
  OrderAdminModel? _orderAdminModel;
  OrderAdminModel? get orderAdminModel => _orderAdminModel;

  Future<void> getAdminOrder() async {
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
        notifyListeners();
      } else {
        debugPrint("Failed: ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("Error fetching admin orders: $error");
    }
  }
}
