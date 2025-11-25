import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';
import '../data/create_order_model.dart';

class OrderViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  OrderData? _orderData;
  OrderData? get orderData => _orderData;

  List<ProductSelectModel> _productList = [];
  List<ProductSelectModel> get productList => _productList;

  void addProduct(ProductSelectModel product) {
    final index = _productList.indexWhere((e) => e.productId == product.productId);

    if (index != -1) {
      // Update quantity if already exists
      _productList[index] = product;
    } else {
      // Add new product
      _productList.add(product);
    }

    debugPrint('Products: ${_productList.map((e) => '${e.productId} = ${e.productQty}')}');
    notifyListeners();
  }

  void removeProduct(String productId) {
    _productList.removeWhere((e) => e.productId == productId);
    debugPrint('Products after removal: $_productList');
    notifyListeners();
  }


  Future<bool> placeOrder() async {
    _isLoading = true;
    _errorMessage = '';
    _orderData = null;
    notifyListeners();

    try {

      final body = {
        "products":[
          {
            "product_id":"cmia5qjk80005ctonnrxrq0p8",
            "quantity":3
          }
        ]
      };

      debugPrint("=== PLACE ORDER API CALLED ===");
      debugPrint("URL: ${ApiEndpoints.placeOrder}");
      debugPrint("BODY: $body");

      final response = await _apiService.post(
        ApiEndpoints.placeOrder,
        data: body,
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = response.data as Map<String, dynamic>;
        final orderResponse = OrderResponseModel.fromJson(jsonResponse);

        _orderData = orderResponse.order;

        debugPrint("ORDER PLACED → ID: ${_orderData?.id}");
        debugPrint("Total Amount: ${_orderData?.totalAmount}");
        debugPrint("Total Items: ${_orderData?.orderItems?.length}");

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final msg =
            response.data['message'] ?? 'Failed to place order. Try again.';
        _errorMessage = msg;
        debugPrint("API Error: $msg");
      }
    } on DioException catch (e) {
      String msg = 'Network error';

      if (e.response != null) {
        msg = e.response?.data['message'] ??
            'Server error ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        msg = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.badResponse) {
        msg = 'Server error. Please try again later.';
      }

      _errorMessage = msg;
      debugPrint("Dio Error: $msg");
    } catch (e) {
      _errorMessage = 'Unexpected error occurred';
      debugPrint("Unexpected Error: $e");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void clear() {
    _orderData = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}
