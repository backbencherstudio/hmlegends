import 'package:flutter/material.dart';
import '../../../../domain/entities/drier/product_entity_driver.dart';
import '../../../../domain/usecase/driver/get_branch_products.dart';
import '../../../../data/repositories/driver/product_repository_impl_driver.dart';

class BranchProductProvider extends ChangeNotifier {
  final GetBranchProducts getBranchProducts;

  BranchProductProvider()
    : getBranchProducts = GetBranchProducts(
        repository: ProductRepositoryImpl(),
      );

  List<ProductEntity> _products = [];
  bool _isLoading = false;

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;

  /// Fetch products from the repository
  Future<void> fetchBranchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await getBranchProducts();
      // Ensure isSelected is not null for items you want checkbox to show initially
      for (var p in _products) {
        if (p.isSelected == null) {
          p.isSelected = null; // initially no checkbox
        }
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Toggle checkbox
  void toggleProductSelection(int index) {
    final product = _products[index];

    product.isSelected = !(product.isSelected ?? false);

    notifyListeners();
  }

  /// Count only selected items
  int get selectedCount => _products.where((p) => p.isSelected == true).length;
}
