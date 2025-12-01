import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin_model/admin_notification_model.dart';
import 'package:http/http.dart' as http;

class AdminNotificationProvider extends ChangeNotifier {
  AdminNotificationProvider() {
    getAdminNotification();
    notifyListeners();
  }
  final TokenStorage _tokenStorage = TokenStorage();

  AdminNotificationModel? _adminNotificationModel;
  AdminNotificationModel? get adminNotificationModel => _adminNotificationModel;
  Future<void> getAdminNotification() async {
    try {
      final url = Uri.parse(ApiEndpoints.adminNotification);
      final token = await _tokenStorage.getToken();

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      final decodeData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _adminNotificationModel = AdminNotificationModel.fromJson(decodeData);
        debugPrint("The success message ${decodeData['message']}");
        debugPrint("The notification length ==== ${_adminNotificationModel?.data?.length}");
      } else {
        debugPrint("The failed message ${decodeData['message']}");
      }
    } catch (error) {
      debugPrint("THe error message $error");
    }
  }
}
