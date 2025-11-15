class AdminInfoModel {
  bool? success;
  Data? data;

  AdminInfoModel({this.success, this.data});

  AdminInfoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  Null? firstName;
  Null? lastName;
  Null? occupation;
  String? email;
  Null? avatar;
  Null? address;
  Null? phoneNumber;
  String? type;
  String? createdAt;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.occupation,
    this.email,
    this.avatar,
    this.address,
    this.phoneNumber,
    this.type,
    this.createdAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    occupation = json['occupation'];
    email = json['email'];
    avatar = json['avatar'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    type = json['type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['occupation'] = this.occupation;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    return data;
  }
}
