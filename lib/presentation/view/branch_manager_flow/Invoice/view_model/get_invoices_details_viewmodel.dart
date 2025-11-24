import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import '../../../../../core/services/api_service.dart';
import '../data/get_invoices_details_model.dart';
import 'package:http/http.dart' as http;

class GetInvoiceDetailViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  final TokenStorage _tokenStorage = TokenStorage();

  InvoiceDetailResponse? _invoiceDetail;
  InvoiceDetailResponse? get invoiceDetail => _invoiceDetail;


  final ApiService _apiService = ApiService();

  Future<bool> fetchInvoiceDetail(String orderID) async {
    _isLoading = true;
    _errorMessage = '';
    _invoiceDetail = null;
    notifyListeners();

    try {
      debugPrint("Inside detail order ID is  $orderID");
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.getInvoiceDetail(orderID));
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("=== INVOICE DETAIL API RESPONSE ===\n\n\n\n\n\n");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      debugPrint("=====================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodeData = jsonDecode(response.body);
        _invoiceDetail = InvoiceDetailResponse.fromJson(decodeData);

        debugPrint("Invoice SKU: ${_invoiceDetail?.data?.sku}");
        debugPrint("success message ${decodeData['message']}");
        debugPrint("Order Total: ${_invoiceDetail?.data?.order?.totalAmount}");
        debugPrint(
          "Items Count: ${_invoiceDetail?.data?.order?.orderItems?.length}",
        );
        debugPrint("The detail data fetch successfully");
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final decodeData = jsonDecode(response.body);

        debugPrint("Invoice SKU: ${_invoiceDetail?.data?.sku}");
        debugPrint("failed message ${decodeData['message']}");
        debugPrint("Order Total: ${_invoiceDetail?.data?.order?.totalAmount}");
        debugPrint(
          "Items Count: ${_invoiceDetail?.data?.order?.orderItems?.length}",
        );
        debugPrint("The detail data fetch failed");
        _errorMessage =
            decodeData['message'] ?? 'Failed to load invoice details';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint("Error fetching invoice detail: $e");
      _errorMessage = "Network error. Please check your connection.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  void clear() {
    _invoiceDetail = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}
