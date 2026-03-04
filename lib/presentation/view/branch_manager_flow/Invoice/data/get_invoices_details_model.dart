class InvoiceDetailResponse {
  bool? success;
  String? message;
  InvoiceDetailData? data;

  InvoiceDetailResponse({this.success, this.message, this.data});

  InvoiceDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? InvoiceDetailData.fromJson(json['data']) : null;
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

class InvoiceDetailData {
  String? id;
  String? orderId;
  String? sku;
  String? status;
  String? createdAt;
  String? url;
  Creator? creator;
  Receiver? receiver;
  Order? order;

  InvoiceDetailData({
    this.id,
    this.orderId,
    this.sku,
    this.status,
    this.createdAt,
    this.url,
    this.creator,
    this.receiver,
    this.order,
  });

  InvoiceDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    sku = json['sku'];
    status = json['status'];
    createdAt = json['created_at'];
    url = json['url'];
    creator =
        json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    receiver =
        json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null;
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['sku'] = sku;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['url'] = url;
    if (creator != null) data['creator'] = creator!.toJson();
    if (receiver != null) data['receiver'] = receiver!.toJson();
    if (order != null) data['order'] = order!.toJson();
    return data;
  }
}

class Creator {
  String? name;
  String? address;
  String? phoneNumber;

  Creator({this.name, this.address, this.phoneNumber});

  Creator.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    return data;
  }
}

class Receiver {
  String? name;
  String? address;
  String? phoneNumber;

  Receiver({this.name, this.address, this.phoneNumber});

  Receiver.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    return data;
  }
}

class Order {
  String? id;
  String? status;
  double? totalAmount;
  int? totalQuantity;
  List<OrderItem>? orderItems;

  Order({
    this.id,
    this.status,
    this.totalAmount,
    this.totalQuantity,
    this.orderItems,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    totalAmount = _toDouble(json['total_amount']);
    totalQuantity = json['total_quantity'];
    if (json['order_items'] != null) {
      orderItems = <OrderItem>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['total_amount'] = totalAmount;
    data['total_quantity'] = totalQuantity;
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0.0;
  }
}

class OrderItem {
  int? quantity;
  double? price;
  Product? product;

  OrderItem({this.quantity, this.price, this.product});

  OrderItem.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = _toDouble(json['price']);
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['price'] = price;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }

  double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0.0;
  }
}

class Product {
  String? name;
  double? price;

  Product({this.name, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = _toDouble(json['price']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    return data;
  }

  double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0.0;
  }
}
