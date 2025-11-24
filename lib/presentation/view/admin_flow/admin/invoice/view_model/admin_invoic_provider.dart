import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;

import '../model/all_invoice_model.dart';

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
}
