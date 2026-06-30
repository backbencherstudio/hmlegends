import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/network/network_service.dart';
import 'package:hmlegends/core/services/api_service.dart';
import '../../data/driver_delivery_model.dart';

class DriverHomeViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  DriverDeliveryModel? _deliveryModel;
  DriverDeliveryModel? get deliveryModel => _deliveryModel;
  List<Data> get deliveries => _deliveryModel?.data ?? [];

  final ApiService _apiService = ApiService();

  Future<void> fetchDeliveries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiEndpoints.driverDelivery);
      logger.d("=== DRIVER DELIVERY RESPONSE: $response ===");

      if (response != null && response['success'] == true) {
        _deliveryModel = DriverDeliveryModel.fromJson(response);
      } else {
        _error = response?['message'] ?? 'Failed to fetch deliveries';
      }
    } catch (e) {
      _error = '$e';
      logger.e("Error fetching driver deliveries: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _isLoading = false;
    _error = null;
    _deliveryModel = null;
    notifyListeners();
  }
}
