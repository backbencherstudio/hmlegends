class ManageBranchModel {
  bool? success;
  String? message;
  Data? data;

  ManageBranchModel({this.success, this.message, this.data});

  ManageBranchModel.fromJson(Map<String, dynamic> json) {
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
  Summary? summary;
  List<Managers>? managers;

  Data({this.summary, this.managers});

  Data.fromJson(Map<String, dynamic> json) {
    summary =
        json['summary'] != null ?  Summary.fromJson(json['summary']) : null;
    if (json['managers'] != null) {
      managers = <Managers>[];
      json['managers'].forEach((v) {
        managers!.add( Managers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (managers != null) {
      data['managers'] = managers!.map((v) => v.toJson()).toList();
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
  String? address; // ✅ now can be String or null
  String? status;
  String? avatar; // ✅ now can be String or null
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
    return {
      'id': id,
      'name': name,
      'address': address,
      'status': status,
      'avatar': avatar,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
