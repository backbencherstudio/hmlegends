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
    final url = Uri.parse(ApiEndpoints.adminOrder);

    try {
      final token = await _tokenStorage.getToken();
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodeData = jsonDecode(response.body);
        _orderAdminModel = OrderAdminModel.fromJson(decodeData);
        debugPrint("The success message is ${decodeData['message']}");
      } else {
        final decodeData = jsonDecode(response.body);
        debugPrint("The failed message is ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("The error message is $error");
    }
  }
}
