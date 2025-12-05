class PendingUserModel {
  bool? success;
  String? message;
  Data? data;

  PendingUserModel({this.success, this.message, this.data});

  PendingUserModel.fromJson(Map<String, dynamic> json) {
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
  int? total;
  List<Users>? users;

  Data({this.total, this.users});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? id;
  String? name;
  String? email;
  String? type;
  String? createdAt;
  Null? address;
  Null? phoneNumber;
  Null? driverId;
  String? approvedBy;

  Users(
      {this.id,
        this.name,
        this.email,
        this.type,
        this.createdAt,
        this.address,
        this.phoneNumber,
        this.driverId,
        this.approvedBy});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    type = json['type'];
    createdAt = json['created_at'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    driverId = json['driver_id'];
    approvedBy = json['approved_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    data['driver_id'] = this.driverId;
    data['approved_by'] = this.approvedBy;
    return data;
  }
}
