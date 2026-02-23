class PendingUserModel {
  bool? success;
  String? message;
  Data? data;

  PendingUserModel({this.success, this.message, this.data});

  PendingUserModel.fromJson(Map<String, dynamic> json) {
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
  int? total;
  List<Users>? users;

  Data({this.total, this.users});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total'] = total;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
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
  dynamic address;
  dynamic phoneNumber;
  dynamic driverId;
  String? approvedBy;

  Users({
    this.id,
    this.name,
    this.email,
    this.type,
    this.createdAt,
    this.address,
    this.phoneNumber,
    this.driverId,
    this.approvedBy,
  });

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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['driver_id'] = driverId;
    data['approved_by'] = approvedBy;
    return data;
  }
}
