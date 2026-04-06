class ManagerNotificationModel {
  bool? success;
  List<Data>? data;
  dynamic nextCursor;

  ManagerNotificationModel({this.success, this.data, this.nextCursor});

  ManagerNotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    nextCursor = json['nextCursor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['nextCursor'] = nextCursor;
    return data;
  }
}

class Data {
  String? id;
  String? entityId;
  String? createdAt;
  dynamic readAt;
  Sender? sender;
  Sender? receiver;
  NotificationEvent? notificationEvent;

  Data({
    this.id,
    this.entityId,
    this.createdAt,
    this.readAt,
    this.sender,
    this.receiver,
    this.notificationEvent,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entityId = json['entity_id'];
    createdAt = json['created_at'];
    readAt = json['read_at'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? Sender.fromJson(json['receiver']) : null;
    notificationEvent =
        json['notification_event'] != null
            ? NotificationEvent.fromJson(json['notification_event'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['entity_id'] = entityId;
    data['created_at'] = createdAt;
    data['read_at'] = readAt;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (receiver != null) {
      data['receiver'] = receiver!.toJson();
    }
    if (notificationEvent != null) {
      data['notification_event'] = notificationEvent!.toJson();
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

  Sender({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
    this.avatarUrl,
  });

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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['avatar'] = avatar;
    data['avatar_url'] = avatarUrl;
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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['text'] = text;
    return data;
  }
}
