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
  User? user;
  int? finalQuantity;

  Order(
      {this.id,
      this.totalQuantity,
      this.createdAt,
      this.status,
      this.orderItems,
      this.user,
      this.finalQuantity});

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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    finalQuantity = json['final_quantity'];
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
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['final_quantity'] = finalQuantity;
    return data;
  }
}

class OrderItems {
  String? id;
  int? quantity;
  int? price;
  int? tax;
  String? itemStatus;
  String? approvedAt;
  String? pickedAt;
  String? deliveredAt;
  Product? product;

  OrderItems(
      {this.id,
      this.quantity,
      this.price,
      this.tax,
      this.itemStatus,
      this.approvedAt,
      this.pickedAt,
      this.deliveredAt,
      this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    tax = json['tax'];
    itemStatus = json['item_status'];
    approvedAt = json['approved_at'];
    pickedAt = json['picked_at'];
    deliveredAt = json['delivered_at'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['quantity'] = quantity;
    data['price'] = price;
    data['tax'] = tax;
    data['item_status'] = itemStatus;
    data['approved_at'] = approvedAt;
    data['picked_at'] = pickedAt;
    data['delivered_at'] = deliveredAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  String? id;
  String? name;
  String? image;

  Product({this.id, this.name, this.image});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class User {
  String? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
