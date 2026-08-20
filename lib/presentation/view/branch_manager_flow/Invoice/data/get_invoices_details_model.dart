class InvoiceDetailResponse {
  bool? success;
  String? message;
  Data? data;

  InvoiceDetailResponse({this.success, this.message, this.data});

  InvoiceDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  String? orderId;
  String? sku;
  String? status;
  String? createdAt;
  String? url;
  double? subtotal;
  double? taxAmount;
  double? totalAmount;
  Creator? creator;
  Creator? receiver;
  Order? order;

  Data({
    this.id,
    this.orderId,
    this.sku,
    this.status,
    this.createdAt,
    this.url,
    this.subtotal,
    this.taxAmount,
    this.totalAmount,
    this.creator,
    this.receiver,
    this.order,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    sku = json['sku'];
    status = json['status'];
    createdAt = json['created_at'];
    url = json['url'];
    subtotal = (json['subtotal'] as num?)?.toDouble();
    taxAmount = (json['tax_amount'] as num?)?.toDouble();
    totalAmount = (json['total_amount'] as num?)?.toDouble();
    creator =
        json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    receiver = json['receiver'] != null
        ? Creator.fromJson(json['receiver'])
        : null;
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
    data['subtotal'] = subtotal;
    data['tax_amount'] = taxAmount;
    data['total_amount'] = totalAmount;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    if (receiver != null) {
      data['receiver'] = receiver!.toJson();
    }
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Creator {
  String? name;
  String? address;
  String? phoneNumber;
  String? email;

  Creator({this.name, this.address, this.phoneNumber, this.email});

  Creator.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    return data;
  }
}

class Order {
  String? id;
  String? status;
  int? totalQuantity;
  List<OrderItems>? orderItems;

  Order({this.id, this.status, this.totalQuantity, this.orderItems});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    totalQuantity = json['total_quantity'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['total_quantity'] = totalQuantity;
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  String? productName;
  int? quantity;
  double? price;
  double? taxPercent;
  double? total;

  OrderItems({
    this.productName,
    this.quantity,
    this.price,
    this.taxPercent,
    this.total,
  });

  OrderItems.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    quantity = (json['quantity'] as num?)?.toInt();
    price = (json['price'] as num?)?.toDouble();
    taxPercent = (json['tax_percent'] as num?)?.toDouble();
    total = (json['total'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['tax_percent'] = taxPercent;
    data['total'] = total;
    return data;
  }
}
