class InvoiceDetailModel {
  final bool success;
  final String message;
  final InvoiceData data;

  InvoiceDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) =>
      InvoiceDetailModel(
        success: json["success"],
        message: json["message"],
        data: InvoiceData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class InvoiceData {
  final String id;
  final String orderId;
  final String sku;
  final String status;
  final String createdAt;
  final String url; // Added URL field
  final Person creator;
  final Person receiver;
  final Order order;

  InvoiceData({
    required this.id,
    required this.orderId,
    required this.sku,
    required this.status,
    required this.createdAt,
    required this.url, // Added URL
    required this.creator,
    required this.receiver,
    required this.order,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
    id: json["id"],
    orderId: json["order_id"],
    sku: json["sku"],
    status: json["status"],
    createdAt: json["created_at"],
    url: json["url"], // Parse URL
    creator: Person.fromJson(json["creator"]),
    receiver: Person.fromJson(json["receiver"]),
    order: Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "sku": sku,
    "status": status,
    "created_at": createdAt,
    "url": url, // Include URL in JSON
    "creator": creator.toJson(),
    "receiver": receiver.toJson(),
    "order": order.toJson(),
  };
}

class Person {
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;

  Person({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    firstName: json["first_name"],
    lastName: json["last_name"],
    address: json["address"],
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "address": address,
    "phone_number": phoneNumber,
  };
}

class Order {
  final String id;
  final String status;
  final int totalAmount;
  final int totalQuantity;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.totalQuantity,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    status: json["status"],
    totalAmount: json["total_amount"],
    totalQuantity: json["total_quantity"],
    orderItems: List<OrderItem>.from(
      json["order_items"].map((x) => OrderItem.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "total_amount": totalAmount,
    "total_quantity": totalQuantity,
    "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
  };
}

class OrderItem {
  final int quantity;
  final int price;
  final Product product;

  OrderItem({
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    quantity: json["quantity"],
    price: json["price"],
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "price": price,
    "product": product.toJson(),
  };
}

class Product {
  final String name;
  final int price;

  Product({required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(name: json["name"], price: json["price"]);

  Map<String, dynamic> toJson() => {"name": name, "price": price};
}
