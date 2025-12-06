class AllDeliveryModelDriver {
  final bool success;
  final String message;
  final List<Data> data;
  final String? cursor;

  AllDeliveryModelDriver({
    required this.success,
    required this.message,
    required this.data,
    this.cursor,
  });

  factory AllDeliveryModelDriver.fromJson(Map<String, dynamic> json) {
    return AllDeliveryModelDriver(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
              : [],
      cursor: json['cursor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((v) => v.toJson()).toList(),
      'cursor': cursor,
    };
  }
}

class Data {
  final String id;
  final int totalQuantity;
  final User? user;
  final Delivery? delivery;

  Data({
    required this.id,
    required this.totalQuantity,
    this.user,
    this.delivery,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? '',
      totalQuantity: json['total_quantity'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      delivery:
          json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_quantity': totalQuantity,
      'user': user?.toJson(),
      'delivery': delivery?.toJson(),
    };
  }
}

class User {
  final String id;
  final String name;
  final String city;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'city': city, 'address': address};
  }
}

class Delivery {
  final String id;
  final String status;
  final String? signatureUrl;

  Delivery({required this.id, required this.status, this.signatureUrl});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      signatureUrl: json['signature_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'status': status, 'signature_url': signatureUrl};
  }
}
