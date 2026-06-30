import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/network/network_service.dart';
import 'package:hmlegends/core/services/api_service.dart';
import '../../data/single_delivery_model.dart';

class DriverBranchDetailViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  SingleDeliveryModel? _deliveryModel;
  SingleDeliveryModel? get deliveryModel => _deliveryModel;
  Data? get deliveryData => _deliveryModel?.data;

  final ApiService _apiService = ApiService();

  Future<void> fetchSingleDelivery(String deliveryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiEndpoints.driverSingleDelivery(deliveryId));
      logger.d("=== DRIVER SINGLE DELIVERY RESPONSE: $response ===");

      if (response != null && response['success'] == true) {
        _deliveryModel = SingleDeliveryModel.fromJson(response);
      } else {
        _error = response?['message'] ?? 'Failed to fetch delivery details';
      }
    } catch (e) {
      _error = '$e';
      logger.e("Error fetching driver single delivery: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateDeliveryStatus(String deliveryId, String checkType) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.patch(
        ApiEndpoints.driverSingleDelivery(deliveryId),
        data: {"check_type": checkType},
      );
      logger.d("=== DRIVER UPDATE DELIVERY STATUS RESPONSE: $response ===");

      if (response != null && response['success'] == true) {
        // Re-fetch to update local state
        await fetchSingleDelivery(deliveryId);
        return true;
      } else {
        _error = response?['message'] ?? 'Failed to update delivery status';
        return false;
      }
    } catch (e) {
      _error = '$e';
      logger.e("Error updating delivery status: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> confirmDelivery(String deliveryId, String note, Uint8List signatureBytes) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        "check_type": "DELIVERED",
        "note": note,
        "signature": MultipartFile.fromBytes(signatureBytes, filename: "signature.png"),
      });

      final response = await _apiService.patch(
        ApiEndpoints.driverSingleDelivery(deliveryId),
        formData: formData,
      );
      
      logger.d("=== DRIVER CONFIRM DELIVERY RESPONSE: $response ===");

      if (response != null && response['success'] == true) {
        return true;
      } else {
        _error = response?['message'] ?? 'Failed to confirm delivery';
        return false;
      }
    } catch (e) {
      _error = '$e';
      logger.e("Error confirming delivery: $e");
      return false;
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
