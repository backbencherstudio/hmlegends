import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/notification/model/manager_notification_model.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class ManagerNotificationProvider extends ChangeNotifier {
  ManagerNotificationProvider() {
    getManagerNotification();
  }

  final TokenStorage _tokenStorage = TokenStorage();

  ManagerNotificationModel? _managerNotificationModel;

  ManagerNotificationModel? get managerNotificationModel =>
      _managerNotificationModel;

  final logger = Logger();

  Future<void> refreshNotifications() async {
    await getManagerNotification();
    notifyListeners();
  }

  Future<void> getManagerNotification() async {
    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.managerNotification);

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _managerNotificationModel = ManagerNotificationModel.fromJson(decoded);
        logger.i(
          'Manager notifications fetched: ${_managerNotificationModel?.data?.length ?? 0}',
        );
      } else {
        logger.e(
          'Failed to fetch notifications: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      logger.e('Error fetching manager notifications: $e');
    }
  }
}
