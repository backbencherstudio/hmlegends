class InvoiceStatusModel {
  bool? success;
  String? message;
  Data? data;

  InvoiceStatusModel({this.success, this.message, this.data});

  InvoiceStatusModel.fromJson(Map<String, dynamic> json) {
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
  Invoice? invoice;
  Branch? branch;
  Order? order;
  Delivery? delivery;

  Data({this.invoice, this.branch, this.order, this.delivery});

  Data.fromJson(Map<String, dynamic> json) {
    invoice =
    json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
    branch =
    json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    delivery = json['delivery'] != null
        ? new Delivery.fromJson(json['delivery'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invoice != null) {
      data['invoice'] = this.invoice!.toJson();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.toJson();
    }
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.delivery != null) {
      data['delivery'] = this.delivery!.toJson();
    }
    return data;
  }
}

class Invoice {
  int? totalInvoice;
  int? paidInvoice;

  Invoice({this.totalInvoice, this.paidInvoice});

  Invoice.fromJson(Map<String, dynamic> json) {
    totalInvoice = json['total_invoice'];
    paidInvoice = json['paid_invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_invoice'] = this.totalInvoice;
    data['paid_invoice'] = this.paidInvoice;
    return data;
  }
}

class Branch {
  int? activeBranch;
  int? lockedBranch;

  Branch({this.activeBranch, this.lockedBranch});

  Branch.fromJson(Map<String, dynamic> json) {
    activeBranch = json['active_branch'];
    lockedBranch = json['locked_branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active_branch'] = this.activeBranch;
    data['locked_branch'] = this.lockedBranch;
    return data;
  }
}

class Order {
  int? totalOrder;
  int? totalCompletedOrder;

  Order({this.totalOrder, this.totalCompletedOrder});

  Order.fromJson(Map<String, dynamic> json) {
    totalOrder = json['total_order'];
    totalCompletedOrder = json['total_completed_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_order'] = this.totalOrder;
    data['total_completed_order'] = this.totalCompletedOrder;
    return data;
  }
}

class Delivery {
  int? todaysDelivery;
  int? assignedDelivery;

  Delivery({this.todaysDelivery, this.assignedDelivery});

  Delivery.fromJson(Map<String, dynamic> json) {
    todaysDelivery = json['todays_delivery'];
    assignedDelivery = json['assigned_delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todays_delivery'] = this.todaysDelivery;
    data['assigned_delivery'] = this.assignedDelivery;
    return data;
  }
}
