import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;
import '../model/all_invoice_model.dart';
import '../model/invoice_detail_model.dart';

class AdminInvoiceProvider extends ChangeNotifier {
  final TokenStorage _tokenStorage = TokenStorage();

  AllInvoiceModel? _allInvoiceModel;
  AllInvoiceModel? get allInvoiceModel => _allInvoiceModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getAllInvoice() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();

      final response = await http.get(
        Uri.parse(
          ApiEndpoints.getAllInvoice,
        ).replace(queryParameters: {"period": "month"}),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        _allInvoiceModel = AllInvoiceModel.fromJson(jsonData);

        final invoices = _allInvoiceModel?.data?.invoices ?? [];
        debugPrint("Total invoices fetched: ${invoices.length}");
        for (int i = 0; i < invoices.length; i++) {
          final receiverName = invoices[i].receiver?.firstName ?? "Unknown";
          debugPrint("Invoice #$i Receiver: $receiverName");
        }
      } else {
        _errorMessage =
            "Failed to fetch invoices • Status: ${response.statusCode}";
        debugPrint(_errorMessage);
        debugPrint("Server Message: ${response.body}");
      }
    } catch (e) {
      _errorMessage = "Exception occurred: $e";
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  InvoiceDetailModel? _invoiceDetailModel;
  InvoiceDetailModel? get invoiceDetailModel => _invoiceDetailModel;

  Future<void> fetchInvoiceDetail(String orderID) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      debugPrint("Inside detail order ID is  $orderID");

      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.getInvoiceDetail(orderID));

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("=== INVOICE DETAIL API RESPONSE ===");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _invoiceDetailModel = InvoiceDetailModel.fromJson(decodeData);

        debugPrint("Invoice SKU: ${_invoiceDetailModel!.data?.sku.length}");
        debugPrint("Success message: ${decodeData['message']}");
        debugPrint("Order Total: ${_invoiceDetailModel!.data?.order.status}");
        debugPrint(
          "Items Count: ${_invoiceDetailModel!.data?.order.orderItems.length}",
        );

        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = decodeData["message"] ?? "Something went wrong";

        debugPrint("API returned error: $_errorMessage");

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching invoice detail: $e");
      _errorMessage = "Network error. Please check your connection.";
      _isLoading = false;
      notifyListeners();
    }
  }
}
