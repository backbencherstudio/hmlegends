class SingleProductModel {
  bool? success;
  String? message;
  Data? data;

  SingleProductModel({this.success, this.message, this.data});

  SingleProductModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? image;
  int? stock;
  int? price;
  String? stockStatus;
  String? createdAt;

  Data(
      {this.id,
        this.name,
        this.image,
        this.stock,
        this.price,
        this.stockStatus,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    stock = json['stock'];
    price = json['price'];
    stockStatus = json['stock_status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['stock_status'] = this.stockStatus;
    data['created_at'] = this.createdAt;
    return data;
  }
}
