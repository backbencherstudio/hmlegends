import '../../entities/drier/product_entity_driver.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getBranchProducts();
}
