
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/orders/data/get_all_products_model.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';
import '../../Invoice/data/get_invoices_details_model.dart';

class GetProductsViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  List<Products> _products = [];
  List<Products> get products => _products;

  String? _nextCursor;
  String? get nextCursor => _nextCursor;

  Future<bool> fetchProducts({bool loadMore = false}) async {
    if (!loadMore) {
      _isLoading = true;
      _errorMessage = '';
      if (!loadMore) _products.clear();
      _nextCursor = null;
    }

    notifyListeners();

    try {
      debugPrint("=== FETCH PRODUCTS API CALLED ===");
      debugPrint("URL: ${ApiEndpoints.getAllProducts}");
      if (loadMore && _nextCursor != null) {
        debugPrint("Load More → Next Cursor: $_nextCursor");
      }

      final response = await _apiService.get(
        ApiEndpoints.getAllProducts,
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.data}");
      debugPrint("======================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = response.data as Map<String, dynamic>;
        final productResponse = ProductResponse.fromJson(jsonResponse);

        if (!loadMore) {
          _products = productResponse.data;
        } else {
          _products.addAll(productResponse.data);
        }

        _nextCursor = productResponse.nextCursor;

        debugPrint("PRODUCTS FETCHED: ${_products.length}");
        debugPrint("Next Cursor: $_nextCursor");

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final msg = response.data['message'] ?? 'Failed to fetch products';
        _errorMessage = msg;
        debugPrint("API Error: $msg");
      }
    } on DioException catch (e) {
      String msg = 'Network error';
      if (e.response != null) {
        msg = e.response?.data['message'] ?? 'Server error ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
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

  Future<bool> loadMoreProducts() async {
    if (_isLoading || _nextCursor == null) return false;
    return await fetchProducts(loadMore: true);
  }

  void clear() {
    _products.clear();
    _nextCursor = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    clear();
    await fetchProducts();
  }
}