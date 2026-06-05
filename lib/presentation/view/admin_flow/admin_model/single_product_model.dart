class SingleProductModel {
  bool? success;
  String? message;
  Data? data;

  SingleProductModel({
    this.success,
    this.message,
    this.data,
  });

  SingleProductModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? image;
  int? stock;
  double? price;
  String? stockStatus;
  String? createdAt;

  Data({
    this.id,
    this.name,
    this.image,
    this.stock,
    this.price,
    this.stockStatus,
    this.createdAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    stock = json['stock'];
    price = (json['price'] as num?)?.toDouble();
    stockStatus = json['stock_status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['stock'] = stock;
    data['price'] = price;
    data['stock_status'] = stockStatus;
    data['created_at'] = createdAt;

    return data;
  }
}