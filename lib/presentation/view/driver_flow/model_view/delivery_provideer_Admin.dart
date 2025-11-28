import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;
import '../model/delivery_mdoel.dart';
import '../model/single_delivery_admin.dart';

class DeliveryProviderAdmin extends ChangeNotifier {
  final TokenStorage _tokenStorage = TokenStorage();
  String? deliveryId;

  setDeliveryId(String deliveredId) {
    debugPrint("The order Id set $deliveredId");
    deliveryId = deliveredId;
    notifyListeners();
  }

  AllDeliveryModelDriver? _allDeliveryModelDriver;
  AllDeliveryModelDriver? get allDeliveryModelDriver => _allDeliveryModelDriver;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getAllDeliveryAdmin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.getAllDeliveryAdmin);

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _allDeliveryModelDriver = AllDeliveryModelDriver.fromJson(decodeData);
        debugPrint(
          "Delivery data fetched successfully: ${decodeData['message']}",
        );
      } else {
        debugPrint("Delivery data fetch failed: ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("Error fetching delivery data: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  SingleDeliveryModelDriver? _singleDeliveryModelDriver;
  SingleDeliveryModelDriver? get singleDeliveryModelDriver =>
      _singleDeliveryModelDriver;

  Future<void> getSingleDeliveryAdmin(String deliveryId) async {
    _isLoading = true;
    notifyListeners();
    debugPrint("The deliveryId is $deliveryId");
    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.getSingleDeliveryDriver(deliveryId));

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      final decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _singleDeliveryModelDriver = SingleDeliveryModelDriver.fromJson(
          decodeData,
        );
        debugPrint(
          "Single Delivery data fetched successfully: ${decodeData['message']}",
        );
      } else {
        debugPrint(
          "Single Delivery data fetch failed: ${decodeData['message']}",
        );
      }
    } catch (error) {
      debugPrint("Error fetching Single delivery data: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deliveryReceivedAdmin(String deliveryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.deliveryReceivedAdmin(deliveryId));

      final response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"check_type": "RECEIVED"}),
      );

      if (response.body.isNotEmpty) {
        final decodeData = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("Delivery successfully marked: ${decodeData['message']}");
        } else {
          debugPrint("Delivery failed: ${decodeData['message']}");
        }
      } else {
        debugPrint("Empty response from server.");
      }
    } catch (error) {
      debugPrint("Error updating delivery: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deliveryConfirmAdmin(String text, File? signatureImage) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.deliveryConfirmAdmin(deliveryId!));

      final request = http.MultipartRequest("PATCH", url);

      request.headers["Authorization"] = "Bearer $token";
      request.headers["Accept"] = "application/json";

      // Add text note
      if (text.isNotEmpty) {
        request.fields["note"] = text;
      }
      request.fields["check_type"] = "DELIVERED";

      if (signatureImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath("signature", signatureImage.path),
        );
      }

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.body.isNotEmpty) {
        final decodeData = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("Delivery successfully marked: ${decodeData['message']}");
        } else {
          debugPrint("Delivery failed-------: ${decodeData['message']}");
        }
      } else {
        debugPrint("Empty response from server.");
      }
    } catch (error) {
      debugPrint("Error updating delivery: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
