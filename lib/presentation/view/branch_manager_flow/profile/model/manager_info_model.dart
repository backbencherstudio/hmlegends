class ManagerInfoModel {
  final bool? success;
  final AdminData? data;

  ManagerInfoModel({
    this.success,
    this.data,
  });

  factory ManagerInfoModel.fromJson(Map<String, dynamic> json) {
    return ManagerInfoModel(
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
  final String? name;
  final String? occupation;
  final String? email;
  final String? avatar;
  final String? address;
  final String? phoneNumber;
  final String? type;
  final String? city;
  final String? dateOfBirth;
  final String? createdAt;
  final String? avatarUrl;

  AdminData({
    this.id,
    this.name,
    this.occupation,
    this.email,
    this.avatar,
    this.address,
    this.phoneNumber,
    this.type,
    this.city,
    this.dateOfBirth,
    this.createdAt,
    this.avatarUrl
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      id: json['id'],
      name: json['name'],
      occupation: json['occupation'],
      email: json['email'],
      avatar: json['avatar'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      type: json['type'],
      city: json['city'],
      dateOfBirth: json['date_of_birth'],
      createdAt: json['created_at'],
      avatarUrl: json['avatar_url']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "occupation": occupation,
      "email": email,
      "avatar": avatar,
      "address": address,
      "phone_number": phoneNumber,
      "type": type,
      "city": city,
      "date_of_birth": dateOfBirth,
      "created_at": createdAt,
      "avatar_url" : avatarUrl
    };
  }
}
