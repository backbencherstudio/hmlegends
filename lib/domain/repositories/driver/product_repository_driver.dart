import '../../entities/driver/product_entity_driver.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getBranchProducts();
}
