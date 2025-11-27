// models/pay_invoice_response.dart
class PayInvoiceResponse {
  final bool success;
  final String message;
  final PayInvoiceData? data;

  PayInvoiceResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PayInvoiceResponse.fromJson(Map<String, dynamic> json) {
    return PayInvoiceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PayInvoiceData.fromJson(json['data']) : null,
    );
  }
}

class PayInvoiceData {
  final String status;
  final String invoiceId;
  final String sku;
  final String orderId;

  PayInvoiceData({
    required this.status,
    required this.invoiceId,
    required this.sku,
    required this.orderId,
  });

  factory PayInvoiceData.fromJson(Map<String, dynamic> json) {
    return PayInvoiceData(
      status: json['status'] ?? '',
      invoiceId: json['invoice_id'] ?? '',
      sku: json['sku'] ?? '',
      orderId: json['order_id'] ?? '',
    );
  }
}