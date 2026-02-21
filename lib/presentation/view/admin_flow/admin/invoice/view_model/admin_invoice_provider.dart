import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import '../model/all_invoice_model.dart';
import '../model/invoice_detail_model.dart';

class AdminInvoiceProvider extends ChangeNotifier {
  final TokenStorage _tokenStorage = TokenStorage();

  AllInvoiceModel? _allInvoiceModel;
  AllInvoiceModel? get allInvoiceModel => _allInvoiceModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final logger = Logger();

  Future<void> getAllInvoice() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final token = await _tokenStorage.getToken();

      final response = await http.get(
        Uri.parse(
          ApiEndpoints.getAllInvoice,
        ).replace(queryParameters: {"period": "month"}),
        headers: {"Authorization": "Bearer $token"},
      );

      logger.i("=== ALL INVOICE API RESPONSE ===");
      logger.i("Response url: ${response.request?.url}");
      logger.i("Status Code: ${response.statusCode}");
      logger.i("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        _allInvoiceModel = AllInvoiceModel.fromJson(jsonData);

        final invoices = _allInvoiceModel?.data?.invoices ?? [];
        logger.i("Total invoices fetched: ${invoices.length}");

      } else {
        _errorMessage =
            "Failed to fetch invoices • Status: ${response.statusCode}";
        logger.e(_errorMessage);
        logger.e("Server Message: ${response.body}");
      }
    } catch (e) {
      _errorMessage = "Exception occurred: $e";
      logger.e(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  InvoiceDetailModel? _invoiceDetailModel;
  InvoiceDetailModel? get invoiceDetailModel => _invoiceDetailModel;

  Future<void> fetchInvoiceDetail(String orderID) async {
    _setLoading(true);
    _errorMessage = '';

    try {
      logger.i("Inside detail order ID is  $orderID");

      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.getInvoiceDetail(orderID));

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      logger.i("=== INVOICE DETAIL API RESPONSE ===");
      logger.i("Response url: ${response.request?.url}");
      logger.i("Status Code: ${response.statusCode}");
      logger.i("Response Body: ${response.body}");

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _invoiceDetailModel = InvoiceDetailModel.fromJson(decodeData);
      } else {
        _errorMessage = decodeData["message"] ?? "Something went wrong";

        logger.e("API returned error: $_errorMessage");
      }
      _setLoading(false);
    } catch (e) {
      logger.e("Error fetching invoice detail: $e");
      _errorMessage = "Network error. Please check your connection.";
      _setLoading(false);
    }
  }
}
