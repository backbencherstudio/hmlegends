class GetAllInvoices {
  bool? success;
  String? message;
  Data? data;

  GetAllInvoices({this.success, this.message, this.data});

  GetAllInvoices.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Invoices>? invoices;
  Stats? stats;

  Data({this.invoices, this.stats});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['invoices'] != null) {
      invoices = <Invoices>[];
      json['invoices'].forEach((v) {
        invoices!.add(new Invoices.fromJson(v));
      });
    }
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invoices != null) {
      data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    }
    if (this.stats != null) {
      data['stats'] = this.stats!.toJson();
    }
    return data;
  }
}

class Invoices {
  String? id;
  String? orderId;
  String? sku;
  String? status;
  String? createdAt;
  Creator? creator;
  Creator? receiver;

  Invoices(
      {this.id,
        this.orderId,
        this.sku,
        this.status,
        this.createdAt,
        this.creator,
        this.receiver});

  Invoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    sku = json['sku'];
    status = json['status'];
    createdAt = json['created_at'];
    creator =
    json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    receiver = json['receiver'] != null
        ? new Creator.fromJson(json['receiver'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['sku'] = this.sku;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    return data;
  }
}

class Creator {
  String? firstName;
  String? lastName;
  String? address;
  String? phoneNumber;

  Creator({this.firstName, this.lastName, this.address, this.phoneNumber});

  Creator.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

class Stats {
  int? pendingInvoice;
  int? paidInvoice;
  int? totalInvoice;

  Stats({this.pendingInvoice, this.paidInvoice, this.totalInvoice});

  Stats.fromJson(Map<String, dynamic> json) {
    pendingInvoice = json['pending_invoice'];
    paidInvoice = json['paid_invoice'];
    totalInvoice = json['total_invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending_invoice'] = this.pendingInvoice;
    data['paid_invoice'] = this.paidInvoice;
    data['total_invoice'] = this.totalInvoice;
    return data;
  }
}
