import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';

import '../../../../../core/services/api_service.dart';
import '../data/get_all_invoice_model.dart';

class GetAllInvoiceProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  GetAllInvoices? _invoiceResponse;
  GetAllInvoices? get invoiceResponse => _invoiceResponse;

  final ApiService _apiService = ApiService();

  Future<bool> fetchAllInvoices() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.get(ApiEndpoints.getInvoices);

      debugPrint("=== RAW API RESPONSE ===");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.data}");
      debugPrint("=========================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _invoiceResponse = GetAllInvoices.fromJson(response.data);

        debugPrint("Parsed Invoices Count: ${_invoiceResponse?.data?.invoices?[0].creator?.firstName ?? 'N/A'}");
        debugPrint("Stats: ${_invoiceResponse?.data?.stats?.toJson()}");

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data['message'] ?? 'Failed to fetch invoices.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint("Error fetching invoices: $e");
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}