import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constant/api_endpoint.dart';

class SocketService with ChangeNotifier {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late io.Socket _socket;
  bool _isInitialized = false;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  SocketService._internal();

  void connect({required String token}) {
    debugPrint("Token is socket: $token");
    if (_isInitialized && _socket.connected) {
      log(' Socket already connected');
      return;
    }

    _socket = io.io(
      ApiEndpoints.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket.connect();
    _isInitialized = true;

    ///  On successful connection
    _socket.onConnect((_) {
      _isConnected = true;
      notifyListeners();
      log('  Socket connected successfully');
    });

    /// On disconnect
    _socket.onDisconnect((_) {
      _isConnected = false;
      notifyListeners();
      log('  Socket disconnected');
    });

    /// On connection error
    _socket.onConnectError((data) {
      log('  Connect Error: $data');
    });

    _socket.onError((data) {
      log(' ️ Socket Error: $data');
    });
  }

  void emit(String event, dynamic data) {
    if (_isConnected) {
      _socket.emit(event, data);
      log(' Event emitted: $event with data: $data');
    } else {
      log(' Cannot emit event, socket not connected.');
    }
  }

  void disconnect() {
    if (_isInitialized) {
      _socket.clearListeners();
      _socket.disconnect();
      _isConnected = false;
      notifyListeners();
      log('  Socket disconnected and listeners cleared');
    }
  }
}
