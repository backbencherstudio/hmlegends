class OrderData {
  final String id;
  final double totalAmount;
  final int totalQuantity;
  final DateTime createdAt;
  final List<OrderItem> items;

  OrderData({
    required this.id,
    required this.totalAmount,
    required this.totalQuantity,
    required this.createdAt,
    required this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      totalQuantity: json['total_quantity'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      items: (json['order_items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final String id;
  final int quantity;
  final double price;
  final Product product;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      product: Product.fromJson(json['product'] ?? {}),
    );
  }
}

class Product {
  final String name;
  final double price;

  Product({
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class OrdersResponse {
  final bool success;
  final String message;
  final List<OrderData> data;

  OrdersResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => OrderData.fromJson(e))
          .toList(),
    );
  }
}
