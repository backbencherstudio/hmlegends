import '../../../data/repositories/driver/product_repository_impl_driver.dart';
import '../../entities/drier/product_entity_driver.dart';
import '../../repositories/driver/product_repository_driver.dart';

class GetBranchProducts {
  final ProductRepository repository;

  GetBranchProducts({ProductRepository? repository})
      : repository = repository ?? ProductRepositoryImpl();

  Future<List<ProductEntity>> call() => repository.getBranchProducts();
}
