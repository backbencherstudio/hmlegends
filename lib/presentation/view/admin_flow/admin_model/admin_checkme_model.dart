class AdminInfoModel {
  bool? success;
  Data? data;

  AdminInfoModel({this.success, this.data});

  AdminInfoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? firstName;
  String? lastName;
  String? occupation;
  String? email;
  String? avatar;
  String? address;
  String? phoneNumber;
  String? type;
  String? createdAt;
  String? city;
  String? dateOfBirth;

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
    this.city,
    this.dateOfBirth,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    firstName = json['first_name'] as String?;
    lastName = json['last_name'] as String?;
    occupation = json['occupation'] as String?;
    email = json['email'] as String?;
    avatar = json['avatar'] as String?;
    address = json['address'] as String?;
    phoneNumber = json['phone_number'] as String?;
    type = json['type'] as String?;
    createdAt = json['created_at'] as String?;
    city = json['city'] as String?;
    dateOfBirth = json['date_of_birth'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['occupation'] = occupation;
    data['email'] = email;
    data['avatar'] = avatar;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['city'] = city;
    data['date_of_birth'] = dateOfBirth;
    return data;
  }
}
