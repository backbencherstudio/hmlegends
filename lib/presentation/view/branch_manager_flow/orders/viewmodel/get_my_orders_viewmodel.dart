import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/api_service.dart';

import '../data/get_my_orders_model.dart';

class GetOrdersViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<OrderData> orders = [];
  String? error;

  final ApiService _apiService = ApiService();

  Future<void> fetchOrders() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _apiService.get(ApiEndpoints.getMyOrders);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = response.data as Map<String, dynamic>;
        final parsed = OrdersResponse.fromJson(jsonData);

        orders = parsed.data;
        error = null;
      } else {
        error = "Failed to fetch orders";
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Group orders by date
  Map<String, List<OrderData>> groupedByDate() {
    Map<String, List<OrderData>> map = {};

    for (var order in orders) {
      String dateKey =
          "${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}";
      map.putIfAbsent(dateKey, () => []);
      map[dateKey]!.add(order);
    }

    return map;
  }
}
