import '../entities/product_entity.dart';

abstract class ProductRepository {
  List<ProductEntity> getAllProducts();
}
