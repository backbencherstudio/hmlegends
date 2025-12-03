import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/token_storage.dart';
import '../../admin_model/admin_notification_model.dart';

class AdminNotificationProvider extends ChangeNotifier {
  AdminNotificationProvider() {
    getAdminNotification();
  }

  final TokenStorage _tokenStorage = TokenStorage();

  AdminNotificationModel? _adminNotificationModel;
  AdminNotificationModel? get adminNotificationModel => _adminNotificationModel;

  Future<void> refreshNotifications() async {
    await getAdminNotification();
    notifyListeners();
  }

  Future<void> getAdminNotification() async {
    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.adminNotification);

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        _adminNotificationModel = AdminNotificationModel.fromJson(decoded);
        debugPrint(
          'Admin notifications fetched: ${_adminNotificationModel?.data?.length ?? 0}',
        );
      } else {
        debugPrint(
          'Failed to fetch notifications: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching admin notifications: $e');
    }
  }
}
