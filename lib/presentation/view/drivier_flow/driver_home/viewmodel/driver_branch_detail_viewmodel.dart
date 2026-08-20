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
      final response = await _apiService.get(
        ApiEndpoints.driverSingleDelivery(deliveryId),
      );
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

  Future<bool> updateDeliveryStatus(
    String deliveryId,
    String checkType, {
    List<String>? itemIds,
    String? note,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> payload = {"check_type": checkType};
      if (itemIds != null && itemIds.isNotEmpty) {
        payload["item_ids"] = itemIds;
      }
      if (note != null && note.trim().isNotEmpty) {
        payload["note"] = note.trim();
      }

      final response = await _apiService.patch(
        ApiEndpoints.driverSingleDelivery(deliveryId),
        data: payload,
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

  Future<bool> confirmDelivery(
    String deliveryId,
    String note,
    Uint8List signatureBytes, {
    List<String>? itemIds,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // If deliveryModel is null, fetch first to get items
      if (_deliveryModel?.data == null) {
        await fetchSingleDelivery(deliveryId);
      }

      final List<String> itemsToDeliver = itemIds ??
          deliveryData?.order?.orderItems
              ?.where((item) =>
                  item.itemStatus?.toUpperCase() == "PICKED" ||
                  (item.itemStatus?.toUpperCase() != "NOT_PICKED" &&
                      item.pickedAt != null))
              .map((item) => item.id ?? "")
              .where((id) => id.isNotEmpty)
              .toList() ??
          [];

      // Fallback: if no items were specifically flagged as PICKED, include all non-empty orderItem ids
      if (itemsToDeliver.isEmpty && deliveryData?.order?.orderItems != null) {
        for (var item in deliveryData!.order!.orderItems!) {
          if (item.id != null && item.id!.isNotEmpty) {
            itemsToDeliver.add(item.id!);
          }
        }
      }

      final formData = FormData.fromMap({
        "check_type": "DELIVERED",
        "note": note,
        "signature": MultipartFile.fromBytes(
          signatureBytes,
          filename: "signature.png",
        ),
      });

      for (final id in itemsToDeliver) {
        formData.fields.add(MapEntry('item_ids', id));
      }

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
