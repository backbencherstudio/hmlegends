class User {
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;

  User({required this.firstName, required this.lastName, required this.address, required this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}

class Invoices {
  final String id;
  final String orderId;
  final String sku;
  final String status;
  final DateTime createdAt;
  final User creator;
  final User receiver;

  Invoices({
    required this.id,
    required this.orderId,
    required this.sku,
    required this.status,
    required this.createdAt,
    required this.creator,
    required this.receiver,
  });

  factory Invoices.fromJson(Map<String, dynamic> json) {
    return Invoices(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      sku: json['sku'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      creator: User.fromJson(json['creator'] ?? {}),
      receiver: User.fromJson(json['receiver'] ?? {}),
    );
  }
}