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
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  int? totalAmount;
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
    totalAmount = json['total_amount'];
    totalQuantity = json['total_quantity'];
    createdAt = json['created_at'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_amount'] = this.totalAmount;
    data['total_quantity'] = this.totalQuantity;
    data['created_at'] = this.createdAt;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  String? id;
  int? quantity;
  int? price;
  String? product;
  String? productImage;

  OrderItems(
      {this.id, this.quantity, this.price, this.product, this.productImage});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    product = json['product'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['product'] = this.product;
    data['product_image'] = this.productImage;
    return data;
  }
}
