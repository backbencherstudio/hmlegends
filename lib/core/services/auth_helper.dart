import 'package:flutter/material.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/core/services/user_type_storage.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/main.dart';

class AuthHelper {
  static bool _isRedirecting = false;

  static Future<void> handleUnauthorized({String? message}) async {
    if (_isRedirecting) return;
    _isRedirecting = true;

    try {
      await TokenStorage().clearToken();
      await UserTypeStorage().clearUserType();

      if (message != null && message.isNotEmpty) {
        Utils.showToast(
          msg: message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteNames.loginScreen,
          (route) => false,
        );
      });
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        _isRedirecting = false;
      });
    }
  }
}
