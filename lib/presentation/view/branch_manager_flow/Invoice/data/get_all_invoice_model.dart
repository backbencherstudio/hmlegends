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
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

// -----------------------------
// Data Model (Invoices + Stats)
// -----------------------------
class InvoiceData {
  final List<Invoice> invoices;
  final InvoiceStats stats;

  InvoiceData({required this.invoices, required this.stats});

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      invoices:
          (json['invoices'] as List).map((e) => Invoice.fromJson(e)).toList(),
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
  final dynamic url;
  final String createdAt;
  final String branchName;
  final int totalQuantity;

  Invoice({
    required this.id,
    required this.orderId,
    required this.url,

    required this.createdAt,
    required this.branchName,
    required this.totalQuantity,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      orderId: json['order_id'],
      createdAt: json['created_at'],
      url: json['url'],
      branchName: json['branch_name'],
      totalQuantity: json['total_quantity'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'created_at': createdAt,
      'url': url,
      'branch_name': branchName,
      'total_quantity': totalQuantity,
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
  final dynamic pendingInvoice;
  final dynamic paidInvoice;
  final dynamic totalInvoice;

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
