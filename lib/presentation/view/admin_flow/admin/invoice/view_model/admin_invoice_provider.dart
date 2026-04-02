import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/data/model/response_model.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import '../model/all_invoice_model.dart';
import '../model/invoice_detail_model.dart';

class AdminInvoiceProvider extends ChangeNotifier {
  AdminInvoiceProvider() {
    getAllInvoice();
  }

  final TokenStorage _tokenStorage = TokenStorage();

  AllInvoiceModel? _allInvoiceModel;

  AllInvoiceModel? get allInvoiceModel => _allInvoiceModel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // String? selectedAction;
  //
  // void updateInvoiceAction( String? value) {
  //   _allInvoiceModel?.data?.invoices = value;
  //   notifyListeners();
  // }
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  final logger = Logger();

  String _selectedPeriod = 'Today';
  String get selectedPeriod => _selectedPeriod;

  void setSelectedPeriod(String value) {
    _selectedPeriod = value;
    notifyListeners();
  }

  String _query = '';
  String get query => _query;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }


  /// ------------------------ Get All Invoices --------------------------------
  Future<void> getAllInvoice() async {
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
        notifyListeners();
        final invoices = _allInvoiceModel?.data?.invoices ?? [];
        logger.i("Total invoices fetched: ${invoices.length}");
      } else {
        _errorMessage =
            "Failed to fetch invoices • Status: ${response.statusCode}";
        logger.e(_errorMessage);
        logger.e("Server Message: ${response.body}");
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Exception occurred: $e";
      logger.e(_errorMessage);
      notifyListeners();
    }
  }

  /// ------------------------ Get Invoice Detail ------------------------------
  InvoiceDetailModel? _invoiceDetailModel;

  InvoiceDetailModel? get invoiceDetailModel => _invoiceDetailModel;

  Future<ResponseModel> fetchInvoiceDetail(String orderID) async {
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
        notifyListeners();
        return ResponseModel(success: true, message: decodeData['message']);
      } else {
        logger.e("API returned error: $_errorMessage");
        notifyListeners();
        return ResponseModel(success: false, message: decodeData['message']);
      }
    } catch (e) {
      logger.e("Error fetching invoice detail: $e");
      _errorMessage = "Network error. Please check your connection.";
      notifyListeners();
      return ResponseModel(success: false, message: '$e');
    } finally {
      _setLoading(false);
    }
  }

  Future<ResponseModel> adminSendInvoice(
    String orderId, {
    required String email,
  }) async {
    try {
      _setLoading(true);
      final url = Uri.parse(ApiEndpoints.adminSendInvoice(orderId));
      final token = await _tokenStorage.getToken();

      var body = jsonEncode({"email": email});

      logger.d("=========== $body ===========");

      final response = await http.post(
        url,
        body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      logger.i("=== SEND INVOICE API RESPONSE ===");
      logger.i("Response url: ${response.request?.url}");
      logger.i("Status Code: ${response.statusCode}");
      logger.i("Response Body: ${response.body}");
      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel(success: true, message: decodeData['message']);
      } else {
        return ResponseModel(success: false, message: decodeData['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
