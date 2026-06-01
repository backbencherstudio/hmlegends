import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../core/services/token_storage.dart';
import '../data/get_all_invoice_model.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/constant/api_endpoint.dart';

class GetAllInvoiceProvider extends ChangeNotifier {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  InvoiceResponse? _invoiceResponse;
  InvoiceResponse? get invoiceResponse => _invoiceResponse;

  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedPeriod = 'This Week';
  String get selectedPeriod => _selectedPeriod;

  void updatedPeriod(String value) {
    if (value.toLowerCase() == 'today') {
      _selectedPeriod = 'Today';
    } else if (value.toLowerCase().contains('week')) {
      _selectedPeriod = 'This Week';
    } else if (value.toLowerCase().contains('month')) {
      _selectedPeriod = 'This Month';
    } else {
      _selectedPeriod = value;
    }
    notifyListeners();
    fetchAllInvoices();
  }

  String _query = '';
  String get query => _query;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  /// --------------- Fetch All Invoices ---------------------------------------
  Future<bool> fetchAllInvoices() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final token = await TokenStorage().getToken();
      if (token == null || token.isEmpty) {
        debugPrint('--- Token not found ---');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final apiPeriod = _selectedPeriod.toLowerCase() == 'today'
          ? 'today'
          : _selectedPeriod.toLowerCase().contains('week')
              ? 'week'
              : 'month';

      final response = await _apiService.get(
        ApiEndpoints.managerInvoice(period: apiPeriod),
      );

      debugPrint("=== INVOICE API RESPONSE ===");
      debugPrint("Response: $response");

      if (response is Map<String, dynamic>) {
        final jsonResponse = response;

        if (jsonResponse['success'] == true) {
          _invoiceResponse = InvoiceResponse.fromJson(jsonResponse);
          _errorMessage = '';

          debugPrint("SUCCESS: ${_invoiceResponse!.success}");
          debugPrint("MESSAGE: ${_invoiceResponse!.message}");
          debugPrint(
            "TOTAL INVOICES: ${_invoiceResponse!.data.invoices.length}",
          );
          debugPrint(
            "STATS: Paid=${_invoiceResponse!.data.stats.paidInvoice}, "
            "Pending=${_invoiceResponse!.data.stats.pendingInvoice}, "
            "Total=${_invoiceResponse!.data.stats.totalInvoice}",
          );

          if (_invoiceResponse!.data.invoices.isNotEmpty) {
            final first = _invoiceResponse!.data.invoices.first;
            debugPrint(
              "First Invoice: OrderID=${first.orderId}, "
              "Status=${first.totalQuantity}, Date=${first.createdAt}",
            );
          }

          return true;
        } else {
          _errorMessage = jsonResponse['message'] ?? 'Server error';
          debugPrint("API Error: $_errorMessage");
        }
      } else {
        _errorMessage = 'Invalid response format';
        debugPrint("Error: Invalid response format");
      }
    } on DioException catch (e) {
      String msg = 'Network error';
      if (e.response != null) {
        msg =
            e.response?.data['message'] ??
            'Server error ${e.response?.statusCode}';
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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
