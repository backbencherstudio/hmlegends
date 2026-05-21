// view_model/paid_payment_viewmodel.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';
import '../data/paid_payment_model.dart';

class PayInvoiceViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;
  bool _isPaid = false;
  PayInvoiceResponse? _lastPaymentResponse;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isPaid => _isPaid;
  PayInvoiceResponse? get lastPaymentResponse => _lastPaymentResponse;

  Future<void> payInvoice(String invoiceId) async {
    _isLoading = true;
    _error = null;
    _isPaid = false;
    _lastPaymentResponse = null;
    notifyListeners();

    final String url = ApiEndpoints.paymentPaid(invoiceId);
    debugPrint('Calling Payment URL: $url');

    try {
      // Using PATCH + empty body – exactly like your working Insomnia request
      final response = await _apiService.patch(
        url,
      );

      debugPrint('Response Success: ${response['success']}');

      // Success
      if (response['success'] == true) {
        final payResponse = PayInvoiceResponse.fromJson(response);

        if (payResponse.success == true && payResponse.data?.status == "PAID") {
          _isPaid = true;
          _lastPaymentResponse = payResponse;
          debugPrint('Payment SUCCESS!');
        } else {
          _error = payResponse.message.isNotEmpty
              ? payResponse.message
              : "Payment failed – status not PAID";
        }
      } else {
        // Any failure returned inside response
        _error = response['message'] ?? "Server error";
      }
    } on DioException catch (e) {
      // This is the ONLY place where 404 is caught when ApiService throws
      debugPrint('DioException: ${e.type} | Status: ${e.response?.statusCode}');

      if (e.response?.statusCode == 404) {
        _error =
        "404 – Endpoint not found!\nURL: $url\n\nYour backend server is OFFLINE or Cloudflare tunnel is down.\n\nStart your server again!";
      }
      else if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        _error = "Cannot connect to server.\nCheck internet or restart Cloudflare tunnel.";
      }
      else if (e.response != null) {
        _error = e.response?.data?['message'] ?? "Payment failed";
      }
      else {
        _error = "No internet connection";
      }
    } catch (e) {
      _error = "Unexpected error: $e";
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isPaid = false;
    _error = null;
    _lastPaymentResponse = null;
    notifyListeners();
  }
}