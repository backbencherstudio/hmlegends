class ManageBranchModel {
  bool? success;
  String? message;
  Data? data;

  ManageBranchModel({this.success, this.message, this.data});

  ManageBranchModel.fromJson(Map<String, dynamic> json) {
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
  Summary? summary;
  List<Managers>? managers;

  Data({this.summary, this.managers});

  Data.fromJson(Map<String, dynamic> json) {
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['managers'] != null) {
      managers = <Managers>[];
      json['managers'].forEach((v) {
        managers!.add(new Managers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.managers != null) {
      data['managers'] = this.managers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  int? totalBranch;
  int? totalActiveBranch;
  int? totalLockedBranch;

  Summary({this.totalBranch, this.totalActiveBranch, this.totalLockedBranch});

  Summary.fromJson(Map<String, dynamic> json) {
    totalBranch = json['totalBranch'];
    totalActiveBranch = json['totalActiveBranch'];
    totalLockedBranch = json['totalLockedBranch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalBranch'] = this.totalBranch;
    data['totalActiveBranch'] = this.totalActiveBranch;
    data['totalLockedBranch'] = this.totalLockedBranch;
    return data;
  }
}

class Managers {
  String? id;
  String? name;
  Null? address;
  String? status;
  Null? avatar;
  String? createdAt;
  String? updatedAt;

  Managers({
    this.id,
    this.name,
    this.address,
    this.status,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  Managers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    status = json['status'];
    avatar = json['avatar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['status'] = this.status;
    data['avatar'] = this.avatar;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
