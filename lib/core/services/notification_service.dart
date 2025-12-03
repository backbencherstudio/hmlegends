import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hmlegends/core/services/fm_token_storage.dart';
import 'package:provider/provider.dart';

import '../../presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FcmTokenStorage _fcmTokenStorage = FcmTokenStorage();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _getToken();
    _setupListeners(navigatorKey);
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _getToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM token: $token');

    if (token != null) {
      _fcmTokenStorage.saveFcmToken(token);
      debugPrint('FCM token save: $token');
    }

    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM token refreshed: $newToken');
      _fcmTokenStorage.saveFcmToken(newToken);
      // sendTokenToServer(newToken); // if needed
    });
  }

  void _setupListeners(GlobalKey<NavigatorState> navigatorKey) {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM onMessage: ${message.notification?.title}');
      _refreshNotificationsIfPossible(navigatorKey);

      final ctx = navigatorKey.currentContext;
      if (ctx != null && message.notification != null) {
        _showDialog(
          ctx,
          message.notification!.title,
          message.notification!.body,
        );
      }
    });

    // Background → Foreground
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM onMessageOpenedApp');
      _refreshNotificationsIfPossible(navigatorKey);
    });

    // Terminated → Opened
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint('FCM getInitialMessage');
        _refreshNotificationsIfPossible(navigatorKey);
      }
    });
  }

  void _refreshNotificationsIfPossible(GlobalKey<NavigatorState> navigatorKey) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      debugPrint('No context available to refresh provider');
      return;
    }

    try {
      final provider = Provider.of<AdminNotificationProvider>(
        ctx,
        listen: false,
      );
      provider.refreshNotifications();
    } catch (e) {
      debugPrint('Failed to refresh notifications: $e');
    }
  }

  void _showDialog(BuildContext context, String? title, String? body) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title ?? ''),
            content: Text(body ?? ''),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
