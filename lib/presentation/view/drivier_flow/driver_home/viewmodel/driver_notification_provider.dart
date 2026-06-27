import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/services/token_storage.dart';
import '../../../admin_flow/admin_model/admin_notification_model.dart';

class DriverNotificationProvider extends ChangeNotifier {
  DriverNotificationProvider() {
    getDriverNotification();
  }

  final TokenStorage _tokenStorage = TokenStorage();
  final logger = Logger();

  List<Data> _notifications = [];
  String? _nextCursor;
  String _currentPeriod = 'today';
  bool _isLoading = false;
  bool _isLoadingMore = false;

  List<Data> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _nextCursor != null;
  String get currentPeriod => _currentPeriod;
  int get unreadCount => _notifications.where((n) => n.readAt == null).length;

  /// Kept for badge-count compatibility across screens that reference this.
  AdminNotificationModel? get driverNotificationModel => AdminNotificationModel(
    success: true,
    data: _notifications,
    nextCursor: _nextCursor,
  );

  /// Fetch first page for the given period (resets list).
  Future<void> getDriverNotification({String period = 'today'}) async {
    _isLoading = true;
    _currentPeriod = period;
    _notifications = [];
    _nextCursor = null;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(ApiEndpoints.notification(period: period));

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = AdminNotificationModel.fromJson(decoded);
        _notifications = model.data ?? [];
        _nextCursor = model.nextCursor?.toString();
        logger.i('Notifications fetched: ${_notifications.length}, hasMore: $hasMore');
      } else {
        logger.e('Failed: ${response.statusCode} — ${response.body}');
      }
    } catch (e) {
      logger.e('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load the next page and append to the existing list.
  Future<void> loadMore() async {
    if (!hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      final url = Uri.parse(
        ApiEndpoints.notification(period: _currentPeriod, cursor: _nextCursor),
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = AdminNotificationModel.fromJson(decoded);
        _notifications.addAll(model.data ?? []);
        _nextCursor = model.nextCursor?.toString();
        logger.i('Load more: +${model.data?.length ?? 0}, hasMore: $hasMore');
      } else {
        logger.e('Load more failed: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error loading more notifications: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Mark a single notification as read locally and call the API.
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    _notifications[index].readAt = DateTime.now().toIso8601String();
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      await http.put(
        Uri.parse(ApiEndpoints.markNotificationRead(id)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      logger.e('Error marking notification read: $e');
    }
  }

  /// Mark all notifications as read locally and call the API.
  Future<void> markAllAsRead() async {
    for (final n in _notifications) {
      n.readAt ??= DateTime.now().toIso8601String();
    }
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      await http.put(
        Uri.parse(ApiEndpoints.markAllNotificationsRead),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      logger.e('Error marking all notifications read: $e');
    }
  }

  /// Switch period and re-fetch from the beginning.
  Future<void> changePeriod(String period) async {
    await getDriverNotification(period: period);
  }

  /// Re-fetch the current period from the beginning (used by FCM refresh).
  Future<void> refreshNotifications() async {
    await getDriverNotification(period: _currentPeriod);
  }
}
