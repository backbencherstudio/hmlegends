class SingleDeliveryModelDriver {
  bool? success;
  String? message;
  Data? data;

  SingleDeliveryModelDriver({this.success, this.message, this.data});

  SingleDeliveryModelDriver.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
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

  Data(
      {this.id,
        this.status,
        this.receivedAt,
        this.deliveredAt,
        this.signatureUrl,
        this.order});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    receivedAt = json['received_at'];
    deliveredAt = json['delivered_at'];
    signatureUrl = json['signature_url'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['received_at'] = this.receivedAt;
    data['delivered_at'] = this.deliveredAt;
    data['signature_url'] = this.signatureUrl;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
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
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    totalQuantity = json['total_quantity'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['total_quantity'] = this.totalQuantity;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city'] = this.city;
    data['address'] = this.address;
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
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
