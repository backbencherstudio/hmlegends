class AllDeliveriesModel {
  bool? success;
  String? message;
  List<Data>? data;
  dynamic cursor;

  AllDeliveriesModel({this.success, this.message, this.data, this.cursor});

  AllDeliveriesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    cursor = json['cursor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['cursor'] = cursor;
    return data;
  }
}

class Data {
  String? id;
  int? totalQuantity;
  int? confirmedQuantity;
  User? user;
  String? status;
  List<OrderItems>? orderItems;
  dynamic delivery;

  Data({
    this.id,
    this.totalQuantity,
    this.confirmedQuantity,
    this.user,
    this.status,
    this.orderItems,
    this.delivery,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalQuantity = json['total_quantity'];
    confirmedQuantity = json['confirmed_quantity'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    status = json['status'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
    delivery = json['delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['total_quantity'] = totalQuantity;
    data['confirmed_quantity'] = confirmedQuantity;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['status'] = status;
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    data['delivery'] = delivery;
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
  String? itemStatus;
  int? quantity;
  Product? product;

  OrderItems({this.id, this.itemStatus, this.quantity, this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemStatus = json['item_status'];
    quantity = json['quantity'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['item_status'] = itemStatus;
    data['quantity'] = quantity;
    if(product != null){
      data['product'] = product!.toJson();
    } else {
      data['product'] = product;
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