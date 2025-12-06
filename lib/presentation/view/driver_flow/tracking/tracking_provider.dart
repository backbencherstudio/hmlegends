import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// ড্রাইভারের স্ট্যাটাস সংজ্ঞায়িত করা হয়েছে
enum DriverStatus {
  Office,
  OnTheWay,
  Arrived
}

class TrackingProvider extends ChangeNotifier {
  // ১. স্টেট ভেরিয়েবলস
  Timer? _locationUpdateTimer; // Timer ব্যবহার করা হয়েছে
  bool _isTracking = false;
  DriverStatus _currentStatus = DriverStatus.Office;

  // ট্র্যাকিংয়ের ফ্রিকোয়েন্সি (১০ সেকেন্ড)
  static const int _updateIntervalSeconds = 10;

  double _latitude = 0.0;
  double _longitude = 0.0;
  String _lastUpdateTime = 'N/A';

  // Getter Methods (UI-তে ডেটা দেখানোর জন্য)
  bool get isTracking => _isTracking;
  DriverStatus get currentStatus => _currentStatus;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get lastUpdateTime => _lastUpdateTime;

  // স্ট্যাটাসকে বাংলায় দেখানোর জন্য ইউটিলিটি
  String get statusBangla {
    switch (_currentStatus) {
      case DriverStatus.Office:
        return 'Office';
      case DriverStatus.OnTheWay:
        return ' (On the way)';
      case DriverStatus.Arrived:
        return 'reach branch';
    }
  }

  // ২. লোকেশন পারমিশন হ্যান্ডলিং (আগের মতো)
  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage(context, 'লোকেশান সার্ভিস বন্ধ আছে। দয়া করে চালু করুন।');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMessage(context, 'লোকেশান পারমিশন দেওয়া হয়নি।');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showMessage(context, 'পার্মানেন্টলি ডিনাই করা হয়েছে।');
      return false;
    }
    return true;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // ৩. লোকেশন আপডেট হ্যান্ডলার (সার্ভারে ডেটা পাঠানোর ফেইক ফাংশন)
  void _handleLocationUpdate(Position position) {
    _latitude = position.latitude;
    _longitude = position.longitude;
    // সময় ফরম্যাট করা
    _lastUpdateTime = DateTime.now().toLocal().toString().substring(11, 19);

    // এইখানে ব্যাকএন্ডে HTTP POST রিকোয়েস্ট পাঠানোর লজিক থাকবে
    print('Sending data to server: Lat: $_latitude, Lon: $_longitude, Status: $_currentStatus, Time: $_lastUpdateTime');

    // UI আপডেট করার জন্য
    notifyListeners();
  }

  // ৪. ট্র্যাকিং শুরু করার ফাংশন ("Start Duty" - অফিস ত্যাগ)
  Future<void> startTracking(BuildContext context) async {
    if (!_isTracking && await _handleLocationPermission(context)) {
      _isTracking = true;
      _currentStatus = DriverStatus.OnTheWay;
      notifyListeners();

      _showMessage(context, 'ডিউটি শুরু হয়েছে: ট্র‍্যাকিং চালু');

      // ট্র্যাকিং শুরু করার সাথে সাথেই একবার লোকেশন আপডেট করা
      try {
        Position initialPosition = await Geolocator.getCurrentPosition();
        _handleLocationUpdate(initialPosition);
      } catch (e) {
        print('Initial position error: $e');
      }

      // প্রতি ১০ সেকেন্ডে লোকেশন পোল করার জন্য Timer সেট করা
      _locationUpdateTimer = Timer.periodic(
        const Duration(seconds: _updateIntervalSeconds),
            (Timer t) async {
          if (_isTracking) {
            try {
              Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              _handleLocationUpdate(position);
            } catch (e) {
              print('Error getting position via Timer: $e');
              // ট্র‍্যাকিং ত্রুটি হলেও স্ট্যাটাস পরিবর্তন না করে চলতে থাকবে
            }
          } else {
            // যদি কোনো কারণে _isTracking ফলস হয়ে যায়, Timer বন্ধ করে দেওয়া হবে
            _locationUpdateTimer?.cancel();
          }
        },
      );
    }
  }

  // ৫. ট্র্যাকিং বন্ধ করার ফাংশন ("End Trip" - ব্রাঞ্চে পৌঁছানো)
  void _stopTracking() async {
    if (_isTracking) {
      _locationUpdateTimer?.cancel(); // Timer বন্ধ করা
      _isTracking = false;
      _currentStatus = DriverStatus.Arrived;

      // চূড়ান্ত অবস্থান নিয়ে সার্ভারে শেষ আপডেট
      try {
        Position finalPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _handleLocationUpdate(finalPosition);
      } catch (e) {
        print('Could not get final position: $e');
      }

      notifyListeners();
    }
  }

  // UI-তে ব্যবহারের জন্য পাবলিক ফাংশন
  void stopTracking(BuildContext context) {
    _stopTracking();
    _showMessage(context, 'ট্র‍্যাকিং বন্ধ হয়েছে: গন্তব্যে পৌঁছানো সম্পন্ন।');
  }

  // ৬. অ্যাপ বন্ধ হলে রিসোর্স ক্লিনআপ
  @override
  void dispose() {
    _locationUpdateTimer?.cancel(); // Timer ডিসপোজ করা
    super.dispose();
  }
}