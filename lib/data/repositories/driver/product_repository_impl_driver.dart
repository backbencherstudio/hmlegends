import '../../../domain/entities/drier/product_entity_driver.dart';
import '../../../domain/repositories/driver/product_repository_driver.dart';
import '../../datasources/driver/product_data_source_driver.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl() : dataSource = ProductDataSource();

  @override
  Future<List<ProductEntity>> getBranchProducts() {
    return dataSource.fetchProducts();
  }
}
