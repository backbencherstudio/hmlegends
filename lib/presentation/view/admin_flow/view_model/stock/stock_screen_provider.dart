import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;

import '../../admin_model/admin_product_model.dart';

class StockScreenProvider extends ChangeNotifier {

  StockScreenProvider(){
    getProduct();
  }
  final TokenStorage _tokenStorage = TokenStorage();

  int _selectIndex = 0;
  int get selectIndex => _selectIndex;

  toggleSelect(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  List<String>? _data = [
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
        debugPrint("Failed: ${decodeData['message']}");
      }
      notifyListeners();
    } catch (error) {
      debugPrint("Error fetching products: $error");
    }
  }

}
