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
  final List<String?> _selectedDriver = ['Admin', 'Driver', 'Manager'];

  List<String?> get selectedDriver => _selectedDriver;

  /// ------------- Function to call all deliveries API -------------------------
  Future<ResponseModel> getAllDeliveries() async {
    try {
      _setLoading(true);

      var response = await _apiService.get(ApiEndpoints.adminAllDelivery);

      final message = response.data['message'];

      if (response.statusCode == 200 || response.statusCode == 201) {
        _allDeliveriesModel = AllDeliveriesModel.fromJson(response.data);

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

  /// ------------------- Function to call all drivers API ---------------------
  Future<ResponseModel> getAllDrivers() async {
    try {
      _setLoading(true);
      final response = await _apiService.get(ApiEndpoints.adminAllDrivers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _allDriversModel = AllDriversModel.fromJson(response.data);

        return ResponseModel(success: true, message: "message");
      } else {
        return ResponseModel(success: false, message: " message");
      }
    } catch (e) {

      return ResponseModel(success: false, message: e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
