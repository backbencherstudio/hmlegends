class CheckMeModelDriver {
  bool? success;
  Data? data;

  CheckMeModelDriver({this.success, this.data});

  CheckMeModelDriver.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
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
    city = json['city'];
    dateOfBirth = json['date_of_birth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
