class AllDeliveryModelDriver {
  bool? success;
  String? message;
  List<Data>? data;
  Null? cursor;

  AllDeliveryModelDriver({this.success, this.message, this.data, this.cursor});

  AllDeliveryModelDriver.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    cursor = json['cursor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['cursor'] = this.cursor;
    return data;
  }
}

class Data {
  String? id;
  int? totalQuantity;
  User? user;
  Delivery? delivery;

  Data({this.id, this.totalQuantity, this.user, this.delivery});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalQuantity = json['total_quantity'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    delivery = json['delivery'] != null
        ? new Delivery.fromJson(json['delivery'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_quantity'] = this.totalQuantity;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.delivery != null) {
      data['delivery'] = this.delivery!.toJson();
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

class Delivery {
  String? id;
  String? status;
  String? signatureUrl;

  Delivery({this.id, this.status, this.signatureUrl});

  Delivery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    signatureUrl = json['signature_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['signature_url'] = this.signatureUrl;
    return data;
  }
}
