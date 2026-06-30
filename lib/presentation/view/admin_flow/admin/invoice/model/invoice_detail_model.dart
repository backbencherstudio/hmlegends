// =============================
//      INVOICE DETAIL MODEL
// =============================

class InvoiceDetailModel {
  final bool success;
  final String message;
  final InvoiceData? data;

  InvoiceDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) =>
      InvoiceDetailModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null ? InvoiceData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

// =============================
//          INVOICE DATA
// =============================

class InvoiceData {
  final String id;
  final String orderId;
  final String sku;
  final String status;
  final String createdAt;
  final String url;

  final Person creator;
  final Person receiver;
  final Order order;

  InvoiceData({
    required this.id,
    required this.orderId,
    required this.sku,
    required this.status,
    required this.createdAt,
    required this.url,
    required this.creator,
    required this.receiver,
    required this.order,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
    id: json["id"]?.toString() ?? "",
    orderId: json["order_id"]?.toString() ?? "",
    sku: json["sku"] ?? "",
    status: json["status"] ?? "",
    createdAt: json["created_at"] ?? "",
    url: json["url"] ?? "",
    creator: Person.fromJson(json["creator"] ?? {}),
    receiver: Person.fromJson(json["receiver"] ?? {}),
    order: Order.fromJson(json["order"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "sku": sku,
    "status": status,
    "created_at": createdAt,
    "url": url,
    "creator": creator.toJson(),
    "receiver": receiver.toJson(),
    "order": order.toJson(),
  };
}

// =============================
//            PERSON
// =============================

class Person {
  final String name;
  final String address;
  final String phoneNumber;
  final String email;

  Person({
    required this.name,
    required this.address,
    required this.phoneNumber,
    this.email = '',
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    name: json["name"] ?? "",
    address: json["address"] ?? "",
    phoneNumber: json["phone_number"] ?? "",
    email: json["email"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "phone_number": phoneNumber,
    "email": email,
  };
}

// =============================
//             ORDER
// =============================

class Order {
  final String id;
  final String status;
  final double totalAmount;
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
    id: json["id"]?.toString() ?? "",
    status: json["status"] ?? "",
    totalAmount: (json["total_amount"] as num?)?.toDouble() ?? 0.0,
    totalQuantity: json["total_quantity"] ?? 0,
    orderItems:
        (json["order_items"] as List? ?? [])
            .map((x) => OrderItem.fromJson(x))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "total_amount": totalAmount,
    "total_quantity": totalQuantity,
    "order_items": orderItems.map((x) => x.toJson()).toList(),
  };
}

// =============================
//          ORDER ITEM
// =============================

class OrderItem {
  final int quantity;
  final double price;
  final String? product;
  final String? productName;
  final double taxPercent;
  final double subtotal;
  final double taxAmount;
  final double itemTotal;

  OrderItem({
    required this.quantity,
    required this.price,
    required this.product,
    this.productName,
    this.taxPercent = 0,
    this.subtotal = 0,
    this.taxAmount = 0,
    this.itemTotal = 0,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    String? productName;
    if (json['product'] != null) {
      if (json['product'] is Map) {
        productName = json['product']['name']?.toString();
      } else {
        productName = json['product']?.toString();
      }
    }
    // Also check top-level product_name field
    productName ??= json['product_name']?.toString();

    return OrderItem(
      quantity: json["quantity"] ?? 0,
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      product: productName,
      productName: json["product_name"]?.toString(),
      taxPercent: (json["tax_percent"] as num?)?.toDouble() ?? 0.0,
      subtotal: (json["subtotal"] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json["tax_amount"] as num?)?.toDouble() ?? 0.0,
      itemTotal: (json["item_total"] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "price": price,
    "product": product,
    "product_name": productName,
    "tax_percent": taxPercent,
    "subtotal": subtotal,
    "tax_amount": taxAmount,
    "item_total": itemTotal,
  };
}

// =============================
//            PRODUCT
// =============================

// class Product {
//   final String name;
//   final int price;
//
//   Product({required this.name, required this.price});
//
//   factory Product.fromJson(Map<String, dynamic> json) =>
//       Product(name: json["name"] ?? "", price: json["price"] ?? 0);
//
//   Map<String, dynamic> toJson() => {"name": name, "price": price};
// }
