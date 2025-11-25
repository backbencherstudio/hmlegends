// models/product_response_model.dart

class ProductResponse {
  final bool success;
  final String message;
  final List<Products> data;
  final String? nextCursor;

  ProductResponse({
    required this.success,
    required this.message,
    required this.data,
    this.nextCursor,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => Products.fromJson(item as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'next_cursor': nextCursor,
    };
  }

  ProductResponse copyWith({
    bool? success,
    String? message,
    List<Products>? data,
    String? nextCursor,
  }) {
    return ProductResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }
}

class Products {
  final String id;
  final String name;
  final String image;
  final int stock;
  final double price;
  final String stockStatus;
  final DateTime createdAt;

  Products({
    required this.id,
    required this.name,
    required this.image,
    required this.stock,
    required this.price,
    required this.stockStatus,
    required this.createdAt,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      stock: json['stock'] as int,
      price: (json['price'] as num).toDouble(),
      stockStatus: json['stock_status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'stock': stock,
      'price': price,
      'stock_status': stockStatus,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Products copyWith({
    String? id,
    String? name,
    String? image,
    int? stock,
    double? price,
    String? stockStatus,
    DateTime? createdAt,
  }) {
    return Products(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      stockStatus: stockStatus ?? this.stockStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}