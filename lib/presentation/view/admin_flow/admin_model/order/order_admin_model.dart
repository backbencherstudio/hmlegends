class OrderAdminModel {
  bool? success;
  String? message;
  Data? data;

  OrderAdminModel({this.success, this.message, this.data});

  OrderAdminModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Orders>? orders;
  Stats? stats;

  Data({this.orders, this.stats});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add( Orders.fromJson(v));
      });
    }
    stats = json['stats'] != null ?  Stats.fromJson(json['stats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    return data;
  }
}

class Orders {
  String? id;
  int? totalQuantity;
  String? createdAt;
  String? status;
  User? user;

  Orders({this.id, this.totalQuantity, this.createdAt, this.status, this.user});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalQuantity = json['total_quantity'];
    createdAt = json['created_at'];
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['id'] = id;
    data['total_quantity'] = totalQuantity;
    data['created_at'] = createdAt;
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
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
    final Map<String, dynamic> data =  {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Stats {
  int? total;
  int? pending;
  int? invoiced;
  int? delivered;
  int? totalUnitOrdered;

  Stats(
      {this.total,
        this.pending,
        this.invoiced,
        this.delivered,
        this.totalUnitOrdered});

  Stats.fromJson(Map<String, dynamic> json) {
    total = (json['total'] as num?)?.toInt() ??
        (json['total_orders'] as num?)?.toInt();
    pending = (json['pending'] as num?)?.toInt() ??
        (json['pending_orders'] as num?)?.toInt();
    invoiced = (json['invoiced'] as num?)?.toInt() ??
        (json['invoiced_orders'] as num?)?.toInt();
    delivered = (json['delivered'] as num?)?.toInt() ??
        (json['delivered_orders'] as num?)?.toInt() ??
        (json['completed'] as num?)?.toInt();
    totalUnitOrdered = (json['total_unit_ordered'] as num?)?.toInt() ??
        (json['total_units'] as num?)?.toInt() ??
        (json['totalUnitOrdered'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total'] = total;
    data['pending'] = pending;
    data['invoiced'] = invoiced;
    data['delivered'] = delivered;
    data['total_unit_ordered'] = totalUnitOrdered;
    return data;
  }
}
