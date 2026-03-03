import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/api_service.dart';
import 'package:intl/intl.dart';

import '../data/get_my_orders_model.dart';

class GetOrdersViewModel extends ChangeNotifier {
  bool isLoading = false;
  OrderResponse? _orderResponse;

  List<Data> get orders => _orderResponse?.data ?? [];

  String? error;

  final ApiService _apiService = ApiService();

  Future<void> fetchOrders() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _apiService.get(ApiEndpoints.getMyOrders);

      if (response is Map<String, dynamic> && response['success'] == true) {
        _orderResponse = OrderResponse.fromJson(response);
        error = null;
      } else {
        error = response['message'] ?? "Failed to fetch orders";
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Group orders by formatted date
  Map<String, List<Data>> groupedByDate() {
    Map<String, List<Data>> map = {};

    for (var order in orders) {
      if (order.createdAt == null) continue;

      DateTime date = DateTime.parse(order.createdAt!);
      String dateKey = DateFormat('dd/MM/yyyy').format(date);

      map.putIfAbsent(dateKey, () => []);
      map[dateKey]!.add(order);
    }

    return map;
  }
}
