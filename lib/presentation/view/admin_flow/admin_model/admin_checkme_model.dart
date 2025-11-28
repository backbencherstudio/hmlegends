class AdminInfoModel {
  final bool? success;
  final AdminData? data;

  AdminInfoModel({
    this.success,
    this.data,
  });

  factory AdminInfoModel.fromJson(Map<String, dynamic> json) {
    return AdminInfoModel(
      success: json['success'],
      data: json['data'] != null ? AdminData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.toJson(),
    };
  }
}

class AdminData {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? occupation;
  final String? email;
  final String? avatar;
  final String? avatarUrl;
  final String? address;
  final String? phoneNumber;
  final String? type;
  final String? city;
  final String? dateOfBirth;
  final String? createdAt;

  AdminData({
    this.id,
    this.firstName,
    this.lastName,
    this.occupation,
    this.email,
    this.avatar,
    this.avatarUrl,
    this.address,
    this.phoneNumber,
    this.type,
    this.city,
    this.dateOfBirth,
    this.createdAt,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      occupation: json['occupation'],
      email: json['email'],
      avatar: json['avatar'],
      avatarUrl: json['avatar_url'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      type: json['type'],
      city: json['city'],
      dateOfBirth: json['date_of_birth'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "occupation": occupation,
      "email": email,
      "avatar": avatar,
      "avatar_url": avatarUrl,
      "address": address,
      "phone_number": phoneNumber,
      "type": type,
      "city": city,
      "date_of_birth": dateOfBirth,
      "created_at": createdAt,
    };
  }
}
