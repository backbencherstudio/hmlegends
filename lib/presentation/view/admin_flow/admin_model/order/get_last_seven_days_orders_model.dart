class GetLastSevenDaysOrdersModel {
  bool? success;
  String? message;
  List<Data>? data;

  GetLastSevenDaysOrdersModel({this.success, this.message, this.data});

  GetLastSevenDaysOrdersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? formatDate;
  String? plainDate;
  int? totalQuantity;

  Data({this.formatDate, this.plainDate, this.totalQuantity});

  Data.fromJson(Map<String, dynamic> json) {
    formatDate = json['format_date'];
    plainDate = json['plain_date'];
    totalQuantity = json['total_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['format_date'] = formatDate;
    data['plain_date'] = plainDate;
    data['total_quantity'] = totalQuantity;
    return data;
  }
}
