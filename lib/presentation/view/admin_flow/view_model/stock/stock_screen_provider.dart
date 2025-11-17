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

  int _selectIndex = 0;
  int get selectIndex => _selectIndex;

  toggleSelect(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  final List<String>? _data = [
    "All Products",
    "In stock",
    "Stock Low",
    "Out of Stock",
  ];

  List<String>? get data => _data;

  String _selectedFilter = "All Products";

  String get selectedFilter => _selectedFilter;

  AdminProductModel? _adminProductModel;
  AdminProductModel? get adminProductModel => _adminProductModel;
  Future<void> getProduct() async {
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
        debugPrint("Failed====: ${decodeData['message']}");
      }
      notifyListeners();
    } catch (error) {
      debugPrint("Error fetching products: $error");
    }
  }

  SingleProductModel? _singleProductModel;
  SingleProductModel? get singleProductModel => _singleProductModel;

  Future<void> getSingleProductProduct(String pId) async {
    debugPrint("THe product id is $pId");
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodeData = jsonDecode(response.body);

        _singleProductModel = SingleProductModel.fromJson(decodeData);
        debugPrint("Success single Product: ${decodeData['message']}");
      } else {
        final decodeData = jsonDecode(response.body);

        debugPrint("Failed======: ${decodeData['message']}");
      }
      notifyListeners();
    } catch (error) {
      debugPrint("Error fetching products: $error");
    }
  }

  Future<void> deleteProduct(String pid) async {
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
        debugPrint("The product delete successfully ${decodeData['message']}");
      } else {
        debugPrint("The product delete failed ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("The error message is $error");
    }
  }

  Future<void> createProduct({
    required String name,
    required String stock,
    required String price,
    File? image,
  }) async {
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
        debugPrint("Success: ${decodeData['message']}");
      } else {
        debugPrint("Failed: ${decodeData['message']}");
      }
      notifyListeners();
    } catch (error) {
      debugPrint("Error fetching products: $error");
    }
  }

  Future<void> editProduct({
    required pId,
    required String name,
    required String stock,
    required String price,
    File? image,
  }) async {
    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.updateProduct(pId));

      final request = http.MultipartRequest("PATCH", url);

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
        debugPrint("The product update successfully ${decodeData['message']}");
      } else {
        debugPrint("The product update failed ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("The error message $error");
    }
  }
}
