class AdminProductModel {
  bool? success;
  String? message;
  List<Data>? data;
  dynamic nextCursor;

  AdminProductModel({this.success, this.message, this.data, this.nextCursor});

  AdminProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = [];

      if (json['data'] is List) {
        for (var v in json['data']) {
          data!.add(Data.fromJson(v));
        }
      } else if (json['data'] is Map) {
        data!.add(Data.fromJson(json['data']));
      }
    }

    nextCursor = json['next_cursor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['next_cursor'] = this.nextCursor;
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
