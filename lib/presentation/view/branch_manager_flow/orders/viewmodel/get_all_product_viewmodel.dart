import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/orders/data/get_all_products_model.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';

class GetProductsViewmodel extends ChangeNotifier {
  GetProductsViewmodel() {
    fetchProducts();
  }

  /// ------------------------- Loading State ----------------------------------
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  /// ------------------------- Api Service  -----------------------------------
  final ApiService _apiService = ApiService();

  /// ------------------ List of Products Model --------------------------------
  List<Products> _products = [];

  List<Products> get products => _products;

  /// -------------------- Next Cursor -----------------------------------------
  String? _nextCursor;

  String? get nextCursor => _nextCursor;

  /// ----------------------------- Fetch Products -----------------------------
  Future<bool> fetchProducts({bool loadMore = false}) async {
    if (!loadMore) {
      _isLoading = true;
      _errorMessage = '';
      if (!loadMore) _products.clear();
      _nextCursor = null;
    }

    try {
      debugPrint("=== FETCH PRODUCTS API CALLED ===");
      debugPrint("URL: ${ApiEndpoints.getAllProducts}");
      if (loadMore && _nextCursor != null) {
        debugPrint("Load More → Next Cursor: $_nextCursor");
      }

      final response = await _apiService.get(ApiEndpoints.getAllProducts);

      if (response['success'] == true) {
        final productResponse = ProductResponse.fromJson(response);

        if (!loadMore) {
          _products = productResponse.data;
        } else {
          _products.addAll(productResponse.data);
        }

        _nextCursor = productResponse.nextCursor;

        debugPrint("PRODUCTS FETCHED: ${_products.length}");
        debugPrint("Next Cursor: $_nextCursor");

        return true;
      } else {
        final msg = response['message'] ?? 'Failed to fetch products';
        _errorMessage = msg;
        debugPrint("API Error: $msg");
      }
    } on DioException catch (e) {
      String msg = 'Network error';
      if (e.response != null) {
        msg =
            e.response?.data['message'] ??
            'Server error ${e.response?.statusCode}';
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
