class ProductEntity {
  final String name;
  final int quantity;
  final String unit;
  bool? isSelected; // nullable → optional checkbox

  ProductEntity({
    required this.name,
    required this.quantity,
    required this.unit,
    this.isSelected, // null → no checkbox
  });
}
