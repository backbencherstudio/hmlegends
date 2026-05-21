class InvoiceStatusModel {
  bool? success;
  String? message;
  Data? data;

  InvoiceStatusModel({this.success, this.message, this.data});

  InvoiceStatusModel.fromJson(Map<String, dynamic> json) {
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
  Invoice? invoice;
  Branch? branch;
  Order? order;
  Delivery? delivery;

  Data({this.invoice, this.branch, this.order, this.delivery});

  Data.fromJson(Map<String, dynamic> json) {
    invoice =
        json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null;
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    delivery =
        json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (invoice != null) {
      data['invoice'] = invoice!.toJson();
    }
    if (branch != null) {
      data['branch'] = branch!.toJson();
    }
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (delivery != null) {
      data['delivery'] = delivery!.toJson();
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
    final Map<String, dynamic> data = {};
    data['total_invoice'] = totalInvoice;
    data['paid_invoice'] = paidInvoice;
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
    final Map<String, dynamic> data = {};
    data['active_branch'] = activeBranch;
    data['locked_branch'] = lockedBranch;
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
    final Map<String, dynamic> data = {};
    data['total_order'] = totalOrder;
    data['total_completed_order'] = totalCompletedOrder;
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
    final Map<String, dynamic> data = {};
    data['todays_delivery'] = todaysDelivery;
    data['assigned_delivery'] = assignedDelivery;
    return data;
  }
}
