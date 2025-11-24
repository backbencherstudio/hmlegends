class OrderResponseModel {
  final bool? success;
  final String? message;
  final OrderData? order;

  OrderResponseModel({this.success, this.message, this.order});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      success: json["success"],
      message: json["message"],
      order: json["order"] == null ? null : OrderData.fromJson(json["order"]),
    );
  }
}

class OrderData {
  final String? id;
  final int? totalAmount;
  final int? totalQuantity;
  final String? createdAt;
  final List<OrderItem>? orderItems;

  OrderData({
    this.id,
    this.totalAmount,
    this.totalQuantity,
    this.createdAt,
    this.orderItems,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json["id"],
      totalAmount: json["total_amount"],
      totalQuantity: json["total_quantity"],
      createdAt: json["created_at"],
      orderItems: json["order_items"] == null
          ? []
          : List<OrderItem>.from(
              json["order_items"].map((x) => OrderItem.fromJson(x)),
            ),
    );
  }
}

class OrderItem {
  final String? id;
  final int? quantity;
  final int? price;
  final ProductInfo? product;

  OrderItem({this.id, this.quantity, this.price, this.product});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"],
      quantity: json["quantity"],
      price: json["price"],
      product: json["product"] == null
          ? null
          : ProductInfo.fromJson(json["product"]),
    );
  }
}

class ProductInfo {
  final String? userId;
  final String? name;
  final int? price;

  ProductInfo({this.userId, this.name, this.price});

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      userId: json["user_id"],
      name: json["name"],
      price: json["price"],
    );
  }
}

class ProductSelectModel {
  final String productId;
  final int productQty;

  ProductSelectModel({required this.productId, required this.productQty});

  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': productQty};
  }
}
