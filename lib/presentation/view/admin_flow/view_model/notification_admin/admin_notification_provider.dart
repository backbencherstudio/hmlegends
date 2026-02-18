import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

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

  final logger = Logger();

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

      logger.i('Request URL: $url');
      logger.i('Status Code: ${response.statusCode}');
      logger.i('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        _adminNotificationModel = AdminNotificationModel.fromJson(decoded);
        logger.i(
          'Admin notifications fetched: ${_adminNotificationModel?.data?.length ?? 0}',
        );
      } else {
        logger.e(
          'Failed to fetch notifications: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      logger.e('Error fetching admin notifications: $e');
    }
  }


}
