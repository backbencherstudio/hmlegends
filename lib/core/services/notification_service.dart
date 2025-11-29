import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class NotificationService {
  /// Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  /// Initialize FCM
  Future<void> init(BuildContext context) async {
    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permissions
    await _requestPermission();

    // Get token
    await _getToken();

    // Setup listeners
    _setupListeners(context);
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  /// Get FCM token
  Future<void> _getToken() async {
    _fcmToken = await _messaging.getToken();

    // Debug print token
    debugPrint('FCM Token: $_fcmToken');

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      debugPrint("FCM Token refreshed: $_fcmToken");
    });
  }


  /// Setup foreground & background listeners
  void _setupListeners(BuildContext context) {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.notification?.title}');
      if (message.notification != null) {
        _showDialog(context, message.notification!.title, message.notification!.body);
      }
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from background by notification');
    });

    // App opened from terminated state
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        print('App opened from terminated state by notification');
      }
    });
  }

  void _showDialog(BuildContext context, String? title, String? body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
