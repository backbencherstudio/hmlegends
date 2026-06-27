class ProductEntity {
  final String name;
  final String image;
  final double price;
  final double? tax;
  final int stock;
  final String status;

  const ProductEntity({
    required this.name,
    required this.image,
    required this.price,
    this.tax,
    required this.stock,
    required this.status,
  });
}
