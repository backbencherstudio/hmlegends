import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;

import '../../admin_model/invoice_status_model.dart';

class HomeScreenProvider extends ChangeNotifier {

  HomeScreenProvider(){
    statusGet();
  }
  final TokenStorage _tokenStorage = TokenStorage();
  InvoiceStatusModel? _invoiceStatusModel;
  InvoiceStatusModel? get invoiceStatusModel => _invoiceStatusModel;

  Future<void> statusGet() async {
    try {
      final url = Uri.parse(ApiEndpoints.adminStatus);
      final token = await _tokenStorage.getToken();
      final response = await http.get(

        url,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodeData = jsonDecode(response.body);
        _invoiceStatusModel = InvoiceStatusModel.fromJson(decodeData);
        debugPrint("The message is ${decodeData['message']}");
      } else {
        final decodeData = jsonDecode(response.body);
        debugPrint("The message is ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("The error message is $error");
    }
  }
}
