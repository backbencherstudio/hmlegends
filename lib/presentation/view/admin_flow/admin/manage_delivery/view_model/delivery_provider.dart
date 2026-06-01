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

  bool _isDriversLoading = false;
  bool get isDriversLoading => _isDriversLoading;

  String? _assigningOrderId;
  String? get assigningOrderId => _assigningOrderId;


  /// --------------- Admin, Driver, Manager -----------------------------------
  final selected = <String>{};
  String? selectedDriverId;
  String? selectedDriverName = "Driver";

  /// ------------- Function to call all deliveries API -------------------------
  Future<ResponseModel> getAllDeliveries() async {
    try {
      _isLoading = true;
      notifyListeners();
      var response = await _apiService.get(ApiEndpoints.adminAllDelivery);

      final message = response['message'] ?? 'Failed to fetch deliveries';

      if (response is Map<String, dynamic> && response['success'] == true) {
        _allDeliveriesModel = AllDeliveriesModel.fromJson(response);
        return ResponseModel(success: true, message: message);
      } else {
        return ResponseModel(success: false, message: message);
      }
    } catch (e) {
      return ResponseModel(success: false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ------------------- Function to call all drivers API ---------------------
  Future<ResponseModel> getAllDrivers() async {
    try {
      _isDriversLoading = true;
      notifyListeners();
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
      _isDriversLoading = false;
      notifyListeners();
    }
  }

  /// ---------------- Function to call assign to driver API -------------------
  Future<ResponseModel> assignToDriver(String orderId, String driverId) async {
    try {
      _assigningOrderId = orderId;
      notifyListeners();
      final response = await _apiService.postHttp(
        ApiEndpoints.adminAssignToDriver,
        data: {"order_id": orderId, "driver_id": driverId},
      );

      if (response is Map<String, dynamic> && response['success'] == true) {
        /// 🔹 Update local status instantly (UI update without reload)
        final deliveries = allDeliveriesModel?.data ?? [];
        final index = deliveries.indexWhere((d) => d.id == orderId);
        if (index != -1) {
          deliveries[index].status = "PROCESSING";
        }
        return ResponseModel(success: true, message: response['message'] ?? 'Successfully assigned to driver');
      } else {
        final msg = response is Map ? response['message'] : 'Failed to assign driver';
        return ResponseModel(success: false, message: msg);
      }
    } catch (e) {
      return ResponseModel(success: false, message: e.toString());
    } finally {
      _assigningOrderId = null;
      notifyListeners();
    }
  }
}
