import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  List<ProductEntity> getAllProducts() {
    return localDataSource.getLocalProducts();
  }
}
