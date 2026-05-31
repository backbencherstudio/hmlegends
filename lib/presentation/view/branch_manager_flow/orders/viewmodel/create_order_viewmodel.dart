import 'package:flutter/material.dart';
import 'package:hmlegends/core/network/network_service.dart';
import 'package:hmlegends/data/model/response_model.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';
import '../data/create_order_model.dart';

class OrderViewmodel extends ChangeNotifier {
  /// ------------------ Loading State -----------------------------------------
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// ----------------------- Error Message ------------------------------------
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  /// ------------------ Api Service -------------------------------------------
  final ApiService _apiService = ApiService();

  /// ------------------ Order Data --------------------------------------------
  OrderResponseModel _orderData = OrderResponseModel();

  OrderResponseModel? get orderData => _orderData;

  bool _hasPlacedToday = false; // ✅ new flag
  bool get hasPlacedToday => _hasPlacedToday;

  final List<ProductSelectModel> _productList = [];

  List<ProductSelectModel> get productList => _productList;

  void addProduct(ProductSelectModel product) {
    final index = _productList.indexWhere(
      (e) => e.productId == product.productId,
    );

    if (index != -1) {
      _productList[index] = product;
    } else {
      _productList.add(product);
    }

    debugPrint(
      'Products: ${_productList.map((e) => '${e.productId} = ${e.productQty}')}',
    );
    notifyListeners();
  }

  void removeProduct(String productId) {
    _productList.removeWhere((e) => e.productId == productId);
    debugPrint('Products after removal: $_productList');
    notifyListeners();
  }

  Future<ResponseModel> placeOrder() async {
    try {
      if (_productList.isEmpty) {
        return ResponseModel(success: false, message: 'No products selected');
      }

      final body = {
        "products": _productList.map((e) => {
          "product_id": e.productId,
          "quantity": int.tryParse(e.productQty) ?? 1,
        }).toList(),
      };

      logger.d("=== PLACE ORDER API CALLED ===");
      final response = await _apiService.postHttp(
        ApiEndpoints.placeOrder,
        data: body,
      );

      if (response['success']) {
        final orderResponse = OrderResponseModel.fromJson(response);

        _orderData = orderResponse;

        _hasPlacedToday = true;

        return ResponseModel(success: true, message: response['message']);
      } else {
        return ResponseModel(success: false, message: response['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }

  void clear() {
    _errorMessage = '';
    _isLoading = false;
    _hasPlacedToday = false;
    notifyListeners();
  }
}
