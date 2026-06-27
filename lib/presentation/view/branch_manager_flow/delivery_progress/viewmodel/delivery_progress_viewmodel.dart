import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/api_service.dart';
import 'package:hmlegends/core/network/network_service.dart';
import '../data/delivery_progress_model.dart';

class DeliveryProgressViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  DeliveryProgressData? _deliveryProgress;
  DeliveryProgressData? get deliveryProgress => _deliveryProgress;

  final ApiService _apiService = ApiService();

  Future<void> fetchDeliveryProgress() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiEndpoints.deliveryProgress);
      logger.d("=== DELIVERY PROGRESS RESPONSE: $response ===");

      if (response != null && response['success'] == true) {
        final progressRes = DeliveryProgressResponse.fromJson(response);
        _deliveryProgress = progressRes.data;
      } else {
        _error = response?['message'] ?? 'Failed to fetch delivery progress';
      }
    } catch (e) {
      _error = '$e';
      logger.e("Error fetching delivery progress: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _isLoading = false;
    _error = null;
    _deliveryProgress = null;
    notifyListeners();
  }
}
