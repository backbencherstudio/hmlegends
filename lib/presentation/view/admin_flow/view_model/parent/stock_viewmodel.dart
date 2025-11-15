import 'package:flutter/material.dart';
import '../../../../../domain/entities/drier/product_entity_driver.dart';
import '../../../../../domain/usecase/get_product_usecase.dart';


class StockViewModel extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;

  StockViewModel(this.getProductsUseCase) {
    loadProducts();
  }

  List<ProductEntity> _products = [];
  String _selectedFilter = "All Products";

  //List<ProductEntity> get products => _filteredProducts;
  String get selectedFilter => _selectedFilter;

  void loadProducts() {
    // _products = getProductsUseCase();
    // notifyListeners();
  }

  void updateFilter(String newFilter) {
    _selectedFilter = newFilter;
    notifyListeners();
  }

  // List<ProductEntity> get _filteredProducts {
  //   switch (_selectedFilter) {
  //     case "In Stock":
  //       return _products.where((p) => p.status == "In Stock").toList();
  //     case "Stock Low":
  //       return _products.where((p) => p.status == "Stock Low").toList();
  //     case "Out of Stock":
  //       return _products.where((p) => p.status == "Out of Stock").toList();
  //     default:
  //       return _products;
  //   }
  // }
}
