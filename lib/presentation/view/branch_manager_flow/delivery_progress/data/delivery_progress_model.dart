class DeliveryProgressResponse {
  final bool? success;
  final String? message;
  final DeliveryProgressData? data;

  DeliveryProgressResponse({this.success, this.message, this.data});

  factory DeliveryProgressResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryProgressResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? DeliveryProgressData.fromJson(json['data']) : null,
    );
  }
}

class DeliveryProgressData {
  final String? deliveryId;
  final String? orderId;
  final String? orderStatus;
  final String? deliveryStatus;
  final Destination? destination;
  final List<ProgressStep>? progress;

  DeliveryProgressData({
    this.deliveryId,
    this.orderId,
    this.orderStatus,
    this.deliveryStatus,
    this.destination,
    this.progress,
  });

  factory DeliveryProgressData.fromJson(Map<String, dynamic> json) {
    return DeliveryProgressData(
      deliveryId: json['deliveryId'],
      orderId: json['orderId'],
      orderStatus: json['orderStatus'],
      deliveryStatus: json['deliveryStatus'],
      destination: json['destination'] != null ? Destination.fromJson(json['destination']) : null,
      progress: json['progress'] != null
          ? List<ProgressStep>.from(json['progress'].map((x) => ProgressStep.fromJson(x)))
          : null,
    );
  }
}

class Destination {
  final String? branchName;
  final String? address;

  Destination({this.branchName, this.address});

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      branchName: json['branchName'],
      address: json['address'],
    );
  }
}

class ProgressStep {
  final String? key;
  final String? label;
  final bool? completed;
  final String? timestamp;

  ProgressStep({this.key, this.label, this.completed, this.timestamp});

  factory ProgressStep.fromJson(Map<String, dynamic> json) {
    return ProgressStep(
      key: json['key'],
      label: json['label'],
      completed: json['completed'],
      timestamp: json['timestamp'],
    );
  }
}
