// -----------------------------
// Main Response Model
// -----------------------------
class InvoiceResponse {
  final bool success;
  final String message;
  final InvoiceData data;

  InvoiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      success: json['success'],
      message: json['message'],
      data: InvoiceData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// -----------------------------
// Data Model (Invoices + Stats)
// -----------------------------
class InvoiceData {
  final List<Invoice> invoices;
  final InvoiceStats stats;

  InvoiceData({
    required this.invoices,
    required this.stats,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      invoices: (json['invoices'] as List)
          .map((e) => Invoice.fromJson(e))
          .toList(),
      stats: InvoiceStats.fromJson(json['stats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoices': invoices.map((e) => e.toJson()).toList(),
      'stats': stats.toJson(),
    };
  }
}

// -----------------------------
// Single Invoice Model
// -----------------------------
class Invoice {
  final String id;
  final String orderId;
  final String sku;
  final String status;
  final String createdAt;
  final Person creator;
  final Person receiver;

  Invoice({
    required this.id,
    required this.orderId,
    required this.sku,
    required this.status,
    required this.createdAt,
    required this.creator,
    required this.receiver,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      orderId: json['order_id'],
      sku: json['sku'],
      status: json['status'],
      createdAt: json['created_at'],
      creator: Person.fromJson(json['creator']),
      receiver: Person.fromJson(json['receiver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'sku': sku,
      'status': status,
      'created_at': createdAt,
      'creator': creator.toJson(),
      'receiver': receiver.toJson(),
    };
  }
}

// -----------------------------
// Person Model
// (Used for creator & receiver)
// -----------------------------
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

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'phone_number': phoneNumber,
    };
  }
}

// -----------------------------
// Stats Model
// -----------------------------
class InvoiceStats {
  final int pendingInvoice;
  final int paidInvoice;
  final int totalInvoice;

  InvoiceStats({
    required this.pendingInvoice,
    required this.paidInvoice,
    required this.totalInvoice,
  });

  factory InvoiceStats.fromJson(Map<String, dynamic> json) {
    return InvoiceStats(
      pendingInvoice: json['pending_invoice'],
      paidInvoice: json['paid_invoice'],
      totalInvoice: json['total_invoice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending_invoice': pendingInvoice,
      'paid_invoice': paidInvoice,
      'total_invoice': totalInvoice,
    };
  }
}
