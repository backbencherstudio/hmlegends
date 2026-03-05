import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/data/model/response_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_delivery/model/all_deliveries_model.dart';
import '../../../../../../core/services/api_service.dart';
import '../model/all_drivers_model.dart';

class DeliveryProvider extends ChangeNotifier {
  DeliveryProvider() {
    getAllDeliveries();
  }

  /// --------------- ApiService -----------------------------------------------
  final _apiService = ApiService();

  /// --------------- Get for All Deliveries Model -----------------------------
  AllDeliveriesModel? _allDeliveriesModel;

  AllDeliveriesModel? get allDeliveriesModel => _allDeliveriesModel;

  /// ------------- Get All Drivers Model --------------------------------------
  AllDriversModel? _allDriversModel;

  AllDriversModel? get allDriversModel => _allDriversModel;

  /// --------------- Loading State --------------------------------------------
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// --------------- Admin, Driver, Manager -----------------------------------
  final selected = <String>{};
  String? selectedDriverId;
  String? selectedDriverName = "Driver";

  /// ------------- Function to call all deliveries API -------------------------
  Future<ResponseModel> getAllDeliveries() async {
    try {
      var response = await _apiService.get(ApiEndpoints.adminAllDelivery);

      final message = response['message'] ?? 'Failed to fetch deliveries';

      if (response is Map<String, dynamic> && response['success'] == true) {
        _allDeliveriesModel = AllDeliveriesModel.fromJson(response);
        notifyListeners();
        return ResponseModel(success: true, message: message);
      } else {
        return ResponseModel(success: false, message: message);
      }
    } catch (e) {
      notifyListeners();
      return ResponseModel(success: false, message: e.toString());
    }
  }

  /// ------------------- Function to call all drivers API ---------------------
  Future<ResponseModel> getAllDrivers() async {
    try {
      _setLoading(true);
      final response = await _apiService.get(ApiEndpoints.adminAllDrivers);

      final message = response['message'] ?? 'Successfully fetched drivers';

      if (response is Map<String, dynamic> && response['success'] == true) {
        _allDriversModel = AllDriversModel.fromJson(response);

        return ResponseModel(success: true, message: message);
      } else {
        return ResponseModel(success: false, message: message);
      }
    } catch (e) {
      return ResponseModel(success: false, message: e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// ---------------- Function to call assign to driver API -------------------
  Future<ResponseModel> assignToDriver(String orderId, String driverId) async {
    try {
      _setLoading(true);
      final response = await _apiService.postHttp(
        ApiEndpoints.adminAssignToDriver,
        data: {"order_id": orderId, "driver_id": driverId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        /// 🔹 Update local status instantly (UI update without reload)
        final deliveries = allDeliveriesModel?.data ?? [];
        final index = deliveries.indexWhere((d) => d.id == orderId);
        if (index != -1) {
          deliveries[index].status = "PROCESSING";
        }
        return ResponseModel(success: true, message: response['message']);
      } else {
        return ResponseModel(success: false, message: response['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
