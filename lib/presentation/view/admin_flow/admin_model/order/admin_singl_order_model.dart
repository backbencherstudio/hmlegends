class AdminSingleOrderModel {
  bool? success;
  String? message;
  Order? order;

  AdminSingleOrderModel({this.success, this.message, this.order});

  AdminSingleOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  String? id;
  int? totalQuantity;
  String? createdAt;
  String? status;
  List<OrderItems>? orderItems;
  Product? product;
  User? user;

  Order({
    this.id,
    this.totalQuantity,
    this.createdAt,
    this.status,
    this.orderItems,
    this.product,
    this.user,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalQuantity = json['total_quantity'];
    createdAt = json['created_at'];
    status = json['status'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['total_quantity'] = totalQuantity;
    data['created_at'] = createdAt;
    data['status'] = status;
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class OrderItems {
  String? id;
  int? quantity;
  Product? product;

  OrderItems({this.id, this.quantity, this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['quantity'] = quantity;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  String? image;

  Product({this.image});

  Product.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['image'] = image;
    return data;
  }
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
