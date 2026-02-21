class AllInvoiceModel {
  bool? success;
  String? message;
  Data? data;

  AllInvoiceModel({this.success, this.message, this.data});

  AllInvoiceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
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
        invoices!.add(Invoices.fromJson(v));
      });
    }
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (invoices != null) {
      data['invoices'] = invoices!.map((v) => v.toJson()).toList();
    }
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    return data;
  }
}

class Invoices {
  String? id;
  String? orderId;
  String? createdAt;
  String? url;
  String? branchName;
  int? totalQuantity;

  Invoices(
      {this.id,
        this.orderId,
        this.createdAt,
        this.url,
        this.branchName,
        this.totalQuantity});

  Invoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    createdAt = json['created_at'];
    url = json['url'];
    branchName = json['branch_name'];
    totalQuantity = json['total_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['order_id'] = orderId;
    data['created_at'] = createdAt;
    data['url'] = url;
    data['branch_name'] = branchName;
    data['total_quantity'] = totalQuantity;
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
    final Map<String, dynamic> data = {};
    data['pending_invoice'] = pendingInvoice;
    data['paid_invoice'] = paidInvoice;
    data['total_invoice'] = totalInvoice;
    return data;
  }
}
