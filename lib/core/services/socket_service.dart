import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constant/api_endpoint.dart';

class SocketService with ChangeNotifier {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket _socket;
  bool _isInitialized = false;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  SocketService._internal();

  void connect({required String token}) {
    debugPrint("Token is socket: $token");
    if (_isInitialized && _socket.connected) {
      print(' Socket already connected');
      return;
    }

    _socket = IO.io(
      ApiEndpoints.baseUrl,
      IO.OptionBuilder()
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
      print('  Socket connected successfully');
    });

    /// On disconnect
    _socket.onDisconnect((_) {
      _isConnected = false;
      notifyListeners();
      print('  Socket disconnected');
    });

    /// On connection error
    _socket.onConnectError((data) {
      print('  Connect Error: $data');
    });

    _socket.onError((data) {
      print(' ️ Socket Error: $data');
    });
  }

  void emit(String event, dynamic data) {
    if (_isConnected) {
      _socket.emit(event, data);
      print(' Event emitted: $event with data: $data');
    } else {
      print(' Cannot emit event, socket not connected.');
    }
  }

  void disconnect() {
    if (_isInitialized) {
      _socket.clearListeners();
      _socket.disconnect();
      _isConnected = false;
      notifyListeners();
      print('  Socket disconnected and listeners cleared');
    }
  }
}