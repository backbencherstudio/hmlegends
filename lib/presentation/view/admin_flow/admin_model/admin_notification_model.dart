class AdminNotificationModel {
  bool? success;
  List<Data>? data;
  Null? nextCursor;

  AdminNotificationModel({this.success, this.data, this.nextCursor});

  AdminNotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    nextCursor = json['nextCursor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['nextCursor'] = this.nextCursor;
    return data;
  }
}

class Data {
  String? id;
  String? entityId;
  String? createdAt;
  Null? readAt;
  Sender? sender;
  Sender? receiver;
  NotificationEvent? notificationEvent;

  Data(
      {this.id,
        this.entityId,
        this.createdAt,
        this.readAt,
        this.sender,
        this.receiver,
        this.notificationEvent});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entityId = json['entity_id'];
    createdAt = json['created_at'];
    readAt = json['read_at'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    receiver =
    json['receiver'] != null ? new Sender.fromJson(json['receiver']) : null;
    notificationEvent = json['notification_event'] != null
        ? new NotificationEvent.fromJson(json['notification_event'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entity_id'] = this.entityId;
    data['created_at'] = this.createdAt;
    data['read_at'] = this.readAt;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    if (this.notificationEvent != null) {
      data['notification_event'] = this.notificationEvent!.toJson();
    }
    return data;
  }
}

class Sender {
  String? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;
  String? avatarUrl;

  Sender(
      {this.id,
        this.name,
        this.firstName,
        this.lastName,
        this.email,
        this.avatar,
        this.avatarUrl});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    avatar = json['avatar'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['avatar_url'] = this.avatarUrl;
    return data;
  }
}

class NotificationEvent {
  String? id;
  String? type;
  String? text;

  NotificationEvent({this.id, this.type, this.text});

  NotificationEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['text'] = this.text;
    return data;
  }
}
