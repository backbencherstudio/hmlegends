import '../../../domain/entities/drier/product_entity_driver.dart'
    show ProductEntity;

class ProductDataSource {
  Future<List<ProductEntity>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ProductEntity(
        name: "Peri Chicken Krunch",
        quantity: 20,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Hot Wings",
        quantity: 15,
        unit: "Pcs",
        isSelected: true,
      ), // no checkbox
      ProductEntity(
        name: "Zinger Burger",
        quantity: 25,
        unit: "Pcs",
        isSelected: false,
      ),
      ProductEntity(
        name: "Peri Chicken Krunch",
        quantity: 20,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Hot Wings",
        quantity: 15,
        unit: "Pcs",
        isSelected: true,
      ), // no checkbox
      ProductEntity(
        name: "Zinger Burger",
        quantity: 25,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Peri Chicken Krunch",
        quantity: 20,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Hot Wings",
        quantity: 15,
        unit: "Pcs",
        isSelected: true,
      ), // no checkbox
      ProductEntity(
        name: "Zinger Burger",
        quantity: 25,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Peri Chicken Krunch",
        quantity: 20,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Hot Wings",
        quantity: 15,
        unit: "Pcs",
        isSelected: true,
      ), // no checkbox
      ProductEntity(
        name: "Zinger Burger",
        quantity: 25,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Peri Chicken Krunch",
        quantity: 20,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Hot Wings",
        quantity: 15,
        unit: "Pcs",
        isSelected: true,
      ), // no checkbox
      ProductEntity(
        name: "Zinger Burger",
        quantity: 25,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Peri Chicken Krunch",
        quantity: 20,
        unit: "Pcs",
        isSelected: true,
      ),
      ProductEntity(
        name: "Hot Wings",
        quantity: 15,
        unit: "Pcs",
        isSelected: true,
      ), // no checkbox
      ProductEntity(
        name: "Zinger Burger",
        quantity: 25,
        unit: "Pcs",
        isSelected: true,
      ),
    ];
  }
}
