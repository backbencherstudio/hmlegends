import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/data/model/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../admin_model/admin_product_model.dart';
import '../../admin_model/single_product_model.dart';

class StockScreenProvider extends ChangeNotifier {
  StockScreenProvider() {
    getProduct();
  }

  final TokenStorage _tokenStorage = TokenStorage();
  final logger = Logger();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
        logger.i("Products fetched: ${_adminProductModel?.data?.length}");
      } else {
        logger.e("Failed: ${decodeData['message']}");
      }
    } catch (error) {
      logger.e("Error fetching products: $error");
    } finally {
      _setLoading(false);
    }
  }

  SingleProductModel? _singleProductModel;

  SingleProductModel? get singleProductModel => _singleProductModel;

  Future<void> getSingleProduct(String pId) async {
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
        logger.i("Single product fetched: ${decodeData['message']}");
      } else {
        logger.e("Failed single product: ${decodeData['message']}");
      }
    } catch (error) {
      logger.e("Error fetching single product: $error");
    } finally {
      _setLoading(false);
    }
  }

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
        logger.i("Product deleted: ${decodeData['message']}");
        await getProduct();
      } else {
        logger.e("Failed to delete product: ${decodeData['message']}");
      }
    } catch (error) {
      logger.e("Error deleting product: $error");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createProduct({
    required String name,
    required String stock,
    required String price,
    String? tax,
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

      if (tax != null && tax.isNotEmpty) {
        request.fields['tax'] = tax;
      }

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", image.path),
        );
      }

      final streamData = await request.send();
      final response = await http.Response.fromStream(streamData);
      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Product created: ${decodeData['message']}");
        await getProduct();
      } else {
        logger.e("Failed to create product: ${decodeData['message']}");
      }
    } catch (error) {
      logger.e("Error creating product: $error");
    } finally {
      _setLoading(false);
    }
  }

  Future<ResponseModel> editProduct({
    required String pId,
    required String name,
    required String stock,
    required String price,
    required String stockStatus,
    String? tax,
    File? image,
  }) async {
    _setLoading(true);
    try {
      final url = Uri.parse(ApiEndpoints.updateProduct(pId));
      final token = await _tokenStorage.getToken();

      final request = http.MultipartRequest("PATCH", url);

      request.headers['Authorization'] = "Bearer $token";
      request.headers['Accept'] = "application/json";

      request.fields['name'] = name;
      request.fields['stock'] = stock;
      request.fields['price'] = price;
      request.fields['stock_status'] = stockStatus;

      if (tax != null && tax.isNotEmpty) {
        request.fields['tax'] = tax;
      }

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", image.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final decodeData = jsonDecode(response.body);

      logger.i("Update response: $decodeData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getProduct();
        return ResponseModel(success: true, message: decodeData['message']);
      } else {
        return ResponseModel(success: false, message: decodeData['message']);
      }
    } catch (error) {
      logger.e("Error updating product: $error");
      return ResponseModel(success: false, message: '$error');
    } finally {
      _setLoading(false);
    }
  }
}
