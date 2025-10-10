import 'package:hmlegends/core/constant/asset_path.dart';

import '../model/product_model.dart';


class ProductLocalDataSource {
  List<ProductModel> getLocalProducts() {
    return const [
      ProductModel(name: "Peri Chicken Wrap", image: AssetPaths.stockImageOne, price: 6.95, stock: 120, status: "In Stock"),
      ProductModel(name: "Billy’s Special", image: AssetPaths.stockImageTwo, price: 8.45, stock: 0, status: "Out of Stock"),
      ProductModel(name: "Chicken Steak & Chips", image: AssetPaths.stockImageOne, price: 6.95, stock: 120, status: "In Stock"),
      ProductModel(name: "Nashville Loaded Fries", image: AssetPaths.stockImageThree, price: 7.45, stock: 5, status: "Stock Low"),
    ];
  }
}
