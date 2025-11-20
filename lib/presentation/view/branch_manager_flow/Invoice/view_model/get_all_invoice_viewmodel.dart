import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/api_service.dart';
import '../../../admin_flow/admin_model/invoice_status_model.dart';
import '../data/get_all_invoice_model.dart';

class InvoiceViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Invoices> _invoices = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Invoices> get invoices => _invoices;

  final ApiService _apiService = ApiService();

  Future<void> fetchInvoices() async {
    _isLoading = true;
    _errorMessage = null;
    print("Fetching invoices...");
    notifyListeners();

    try {
      final response = await _apiService.get(ApiEndpoints.getInvoices);

      print("API Response: ${response.statusCode}");
      print("API Response: ${response.data}");

      final Map<String, dynamic> jsonMap = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      print("Success: ${jsonMap['success']}");

      if (jsonMap['success'] == true) {
        final List<dynamic> list = jsonMap['data']['invoices'];
        print("Found ${list.length} invoices");

        _invoices = list.map((e) => Invoices.fromJson(e)).toList();
      } else {
        _errorMessage = jsonMap['message'] ?? 'Failed';
      }
    } catch (e) {
      print("Error: $e");
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}