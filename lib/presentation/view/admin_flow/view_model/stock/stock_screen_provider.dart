import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;

import '../../admin_model/admin_product_model.dart';
import '../../admin_model/single_product_model.dart';

class StockScreenProvider extends ChangeNotifier {
  StockScreenProvider() {
    getProduct();
  }

  final TokenStorage _tokenStorage = TokenStorage();

  // ---------------- Loading State ----------------
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ---------------- UI Selection ----------------
  int _selectIndex = 0;

  int get selectIndex => _selectIndex;

  void toggleSelect(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  final List<String> _data = [
    "All Products",
    "In stock",
    "Stock Low",
    "Out of Stock",
  ];

  List<String>? get data => _data;

  final String _selectedFilter = "All Products";

  String get selectedFilter => _selectedFilter;

  // ---------------- Product List ----------------
  AdminProductModel? _adminProductModel;

  AdminProductModel? get adminProductModel => _adminProductModel;

  Future<void> getProduct() async {
    _setLoading(true);
    try {
      final url = Uri.parse(ApiEndpoints.adminAllProduct);
      final token = await _tokenStorage.getToken();
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _adminProductModel = AdminProductModel.fromJson(decodeData);
        debugPrint("Success: ${decodeData['message']}");
      } else {
        debugPrint("Failed: ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("Error fetching products: $error");
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- Single Product ----------------
  SingleProductModel? _singleProductModel;

  SingleProductModel? get singleProductModel => _singleProductModel;

  Future<void> getSingleProductProduct(String pId) async {
    _setLoading(true);
    try {
      final url = Uri.parse(ApiEndpoints.fetchSingleProduct(pId));
      final token = await _tokenStorage.getToken();
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _singleProductModel = SingleProductModel.fromJson(decodeData);
        debugPrint("Success single Product: ${decodeData['message']}");
      } else {
        debugPrint("Failed single Product: ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("Error fetching single product: $error");
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- Delete Product ----------------
  Future<void> deleteProduct(String pid) async {
    _setLoading(true);
    try {
      final url = Uri.parse(ApiEndpoints.deleteProduct(pid));
      final token = await _tokenStorage.getToken();
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": 'application/json',
        },
      );

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Product deleted successfully: ${decodeData['message']}");
      } else {
        debugPrint("Failed to delete product: ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("Error deleting product: $error");
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- Create Product ----------------
  Future<void> createProduct({
    required String name,
    required String stock,
    required String price,
    File? image,
  }) async {
    _setLoading(true);
    try {
      final url = Uri.parse(ApiEndpoints.adminCreateProduct);
      final token = await _tokenStorage.getToken();
      final request = http.MultipartRequest("POST", url);

      request.headers['Authorization'] = "Bearer $token";
      request.headers['Accept'] = "application/json";
      request.fields['name'] = name;
      request.fields['stock'] = stock;
      request.fields['price'] = price;

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", image.path),
        );
      }

      final streamData = await request.send();
      final response = await http.Response.fromStream(streamData);
      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _adminProductModel = AdminProductModel.fromJson(decodeData);
        debugPrint("Product created successfully: ${decodeData['message']}");
      } else {
        debugPrint("Failed to create product: ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("Error creating product: $error");
    } finally {
      _setLoading(false);
    }
  }

  /// ---------------- Edit Product ----------------
  Future<void> editProduct({
    required String pId,
    required String name,
    required String stock,
    required String price,
    File? image,
  }) async {
    _setLoading(true);
    try {
      final url = Uri.parse(ApiEndpoints.updateProduct(pId));
      final token = await _tokenStorage.getToken();

      final request = http.MultipartRequest("PATCH", url);

      request.headers['Authorization'] = "Bearer $token";
      request.headers['Accept'] = "application/json";

      // Add fields
      request.fields['name'] = name;
      request.fields['stock'] = stock;
      request.fields['price'] = price;

      // Add image if exists
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", image.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final decodeData = jsonDecode(response.body);
      debugPrint("Update Response: $decodeData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Product updated successfully");
        await getProduct(); // refresh list
      } else {
        debugPrint("Failed to update product: ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("Error updating product: $error");
    } finally {
      _setLoading(false);
    }
  }
}
