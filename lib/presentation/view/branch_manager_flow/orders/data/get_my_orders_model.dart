class OrderResponse {
  bool? success;
  String? message;
  List<Data>? data;

  OrderResponse({this.success, this.message, this.data});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  double? totalAmount;
  int? totalQuantity;
  String? createdAt;
  List<OrderItems>? orderItems;

  Data(
      {this.id,
        this.totalAmount,
        this.totalQuantity,
        this.createdAt,
        this.orderItems});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = (json['total_amount'] as num?)?.toDouble();
    totalQuantity = (json['total_quantity'] as num?)?.toInt();
    createdAt = json['created_at'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add( OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['total_amount'] = totalAmount;
    data['total_quantity'] = totalQuantity;
    data['created_at'] = createdAt;
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  String? id;
  int? quantity;
  double? price;
  String? product;
  String? productImage;

  OrderItems(
      {this.id, this.quantity, this.price, this.product, this.productImage});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = (json['quantity'] as num?)?.toInt();
    price = (json['price'] as num?)?.toDouble();
    product = json['product'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['quantity'] = quantity;
    data['price'] = price;
    data['product'] = product;
    data['product_image'] = productImage;
    return data;
  }
}
