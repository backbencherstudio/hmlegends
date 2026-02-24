import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../core/services/token_storage.dart';
import '../data/get_all_invoice_model.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/constant/api_endpoint.dart';

class GetAllInvoiceProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  InvoiceResponse? _invoiceResponse;
  InvoiceResponse? get invoiceResponse => _invoiceResponse;

  final ApiService _apiService = ApiService();

  Future<bool> fetchAllInvoices() async {
    _isLoading = true;
    _errorMessage = '';
    _invoiceResponse = null;
    notifyListeners();

    try {

      final token = await TokenStorage().getToken();
      if (token == null || token.isEmpty) {
        debugPrint('--- Token not found ---');
        return false;
      }

      final response = await _apiService.get(ApiEndpoints.getInvoices);

      debugPrint("=== INVOICE API RESPONSE ===");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Raw Body: ${response.data}");
      debugPrint("===============================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = response.data as Map<String, dynamic>;

        _invoiceResponse = InvoiceResponse.fromJson(jsonResponse);

        debugPrint("SUCCESS: ${_invoiceResponse!.success}");
        debugPrint("MESSAGE: ${_invoiceResponse!.message}");
        debugPrint("TOTAL INVOICES: ${_invoiceResponse!.data.invoices.length}");
        debugPrint("STATS: Paid=${_invoiceResponse!.data.stats.paidInvoice}, "
            "Pending=${_invoiceResponse!.data.stats.pendingInvoice}, "
            "Total=${_invoiceResponse!.data.stats.totalInvoice}");

        if (_invoiceResponse!.data.invoices.isNotEmpty) {
          final first = _invoiceResponse!.data.invoices.first;
          debugPrint("First Invoice: OrderID=${first.orderId}, "
              "Status=${first.totalQuantity}, Date=${first.createdAt}");
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data['message'] ?? 'Server error';
        debugPrint("API Error: $_errorMessage");
      }
    } on DioException catch (e) {
      String msg = 'Network error';
      if (e.response != null) {
        msg = e.response?.data['message'] ?? 'Server error ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        msg = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        msg = 'Server slow';
      }
      _errorMessage = msg;
      debugPrint("Dio Error: $msg");
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      debugPrint("Unexpected Error: $e");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}