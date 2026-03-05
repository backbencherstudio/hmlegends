class SingleBranchModel {
  bool? success;
  String? message;
  Data? data;

  SingleBranchModel({this.success, this.message, this.data});

  SingleBranchModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? address;
  String? status;
  String? avatar;
  String? createdAt;
  String? updatedAt;
  int? totalOrders;
  List<Orders>? orders;

  Data({
    this.id,
    this.name,
    this.address,
    this.status,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.totalOrders,
    this.orders,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    status = json['status'];
    avatar = json['avatar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalOrders = json['totalOrders'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['status'] = status;
    data['avatar'] = avatar;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['totalOrders'] = totalOrders;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String? id;
  String? createdAt;
  List<OrderItems>? orderItems;

  Orders({this.id, this.createdAt, this.orderItems});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
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
  String? productImage;

  OrderItems({this.id, this.quantity, this.productImage});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['product_image'] = productImage;
    return data;
  }
}
