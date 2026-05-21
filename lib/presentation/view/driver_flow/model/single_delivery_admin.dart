class SingleDeliveryModelDriver {
  bool? success;
  String? message;
  Data? data;

  SingleDeliveryModelDriver({this.success, this.message, this.data});

  SingleDeliveryModelDriver.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? status;
  String? receivedAt;
  String? deliveredAt;
  String? signatureUrl;
  Order? order;

  Data({
    this.id,
    this.status,
    this.receivedAt,
    this.deliveredAt,
    this.signatureUrl,
    this.order,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    receivedAt = json['received_at'];
    deliveredAt = json['delivered_at'];
    signatureUrl = json['signature_url'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['status'] = status;
    data['received_at'] = receivedAt;
    data['delivered_at'] = deliveredAt;
    data['signature_url'] = signatureUrl;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  User? user;
  int? totalQuantity;
  List<OrderItems>? orderItems;

  Order({this.user, this.totalQuantity, this.orderItems});

  Order.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    totalQuantity = json['total_quantity'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['total_quantity'] = totalQuantity;
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? city;
  String? address;

  User({this.id, this.name, this.city, this.address});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['city'] = city;
    data['address'] = address;
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
  String? id;
  String? name;

  Product({this.id, this.name});

  Product.fromJson(Map<String, dynamic> json) {
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
