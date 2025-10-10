import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.name,
    required super.image,
    required super.price,
    required super.stock,
    required super.status,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      image: json['image'],
      price: json['price'],
      stock: json['stock'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'stock': stock,
      'status': status,
    };
  }
}
