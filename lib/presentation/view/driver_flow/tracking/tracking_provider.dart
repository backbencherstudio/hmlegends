import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:http/http.dart' as http;

// ড্রাইভারের স্ট্যাটাস সংজ্ঞায়িত করা হয়েছে
enum DriverStatus { Office, OnTheWay, Arrived }

class TrackingProvider extends ChangeNotifier {
  // ১. স্টেট ভেরিয়েবলস
  Timer? _locationUpdateTimer;
  bool _isTracking = false;
  DriverStatus _currentStatus = DriverStatus.Office;
  String? _deliveryId; // ইনিশিয়ালাইজেশন null করা হলো

  // ⭐ সংশোধন: _deliveryId ইনস্ট্যান্স ভেরিয়েবলে মান সেট করা হলো
  void setDeliveryId(String deliveryId) {
    _deliveryId = deliveryId;
    notifyListeners();
  }

  // Getter ঠিক আছে
  String? get deliveryId => _deliveryId;

  // ট্র্যাকিংয়ের ফ্রিকোয়েন্সি (১০ সেকেন্ড)
  static const int _updateIntervalSeconds = 10;

  double _latitude = 0.0;
  double _longitude = 0.0;
  String _lastUpdateTime = 'N/A';

  // গন্তব্যের জন্য ভেরিয়েবল
  String _destinationAddress = 'N/A';
  double _destLatitude = 0.0;
  double _destLongitude = 0.0;

  // পরামর্শের জন্য নতুন ভেরিয়েবল
  List<Placemark> _addressSuggestions = [];

  // API টোকেন স্টোরেজ
  final TokenStorage _tokenStorage = TokenStorage();

  // Getter Methods (অন্যান্যগুলি অপরিবর্তিত)
  bool get isTracking => _isTracking;
  DriverStatus get currentStatus => _currentStatus;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get lastUpdateTime => _lastUpdateTime;
  String get destinationAddress => _destinationAddress;
  double get destLatitude => _destLatitude;
  double get destLongitude => _destLongitude;
  List<Placemark> get addressSuggestions => _addressSuggestions;

  String get statusBangla {
    switch (_currentStatus) {
      case DriverStatus.Office:
        return 'Office';
      case DriverStatus.OnTheWay:
        return 'On the way';
      case DriverStatus.Arrived:
        return 'reach branch';
    }
  }

  // ২. লোকেশন পারমিশন হ্যান্ডলিং (অপরিবর্তিত)
  Future<bool> _handleLocationPermission(BuildContext context) async {
    // ... (unchanged permission logic) ...
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ৩. লোকেশন আপডেট হ্যান্ডলার
  void _handleLocationUpdate(Position position) {
    _latitude = position.latitude;
    _longitude = position.longitude;
    _lastUpdateTime = DateTime.now().toLocal().toString().substring(11, 19);
    print(
      'Sending data to server: Lat: $_latitude, Lon: $_longitude, Status: $_currentStatus, Time: $_lastUpdateTime',
    );

    // রিয়েল-টাইম আপডেট কল করা হচ্ছে
    if (_isTracking && _deliveryId != null) {
      getRealTimeUpdate(); // ⭐ সংশোধন: deliveryId state থেকে নেওয়া হবে
    }

    notifyListeners();
  }

  // ৪. রিয়েল-টাইম ঠিকানা পরামর্শ খোঁজার ফাংশন (অপরিবর্তিত)
  Future<void> searchAddressSuggestions(String input) async {
    // ... (unchanged search logic) ...
    if (input.length < 3) {
      _addressSuggestions = [];
      notifyListeners();
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(input);

      if (locations.isNotEmpty) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locations.first.latitude,
          locations.first.longitude,
        );
        _addressSuggestions = placemarks;
      } else {
        _addressSuggestions = [];
      }
    } catch (e) {
      print("Error fetching suggestion: $e");
      _addressSuggestions = [];
    }
    notifyListeners();
  }

  // ৫. পরামর্শ থেকে গন্তব্য নির্বাচন ও সেভ করার ফাংশন (অপরিবর্তিত)
  void selectDestinationFromSuggestion(
    BuildContext context,
    Placemark selectedPlacemark,
  ) {
    // ... (unchanged destination selection logic) ...
    final String address =
        '${selectedPlacemark.street}, ${selectedPlacemark.locality}, ${selectedPlacemark.country}';

    locationFromAddress(address)
        .then((locations) {
          if (locations.isNotEmpty) {
            _destLatitude = locations.first.latitude;
            _destLongitude = locations.first.longitude;

            _destinationAddress = address;

            _addressSuggestions = [];

            _showMessage(
              context,
              'গন্তব্য সেট করা হয়েছে: ${_destinationAddress}',
            );
            notifyListeners();
          } else {
            _showMessage(context, 'ঠিকানার স্থানাঙ্ক খুঁজে পাওয়া যায়নি।');
          }
        })
        .catchError((e) {
          print('Location conversion error: $e');
          _showMessage(context, 'ঠিকানা প্রক্রিয়াকরণে ত্রুটি।');
        });
  }

  // ৬. ট্র্যাকিং শুরু করার ফাংশন ("Start Duty")
  Future<void> startTracking(BuildContext context) async {
    if (_destinationAddress == 'N/A' ||
        (_destLatitude == 0.0 && _destLongitude == 0.0)) {
      _showMessage(context, 'দয়া করে আগে গন্তব্য সেট করুন।');
      return;
    }

    // ⭐ সংশোধন: deliveryId চেক করা হচ্ছে
    if (_deliveryId == null || _deliveryId!.isEmpty) {
      _showMessage(context, 'ডিউটি শুরু করার জন্য ডেলিভারি আইডি সেট করুন।');
      return;
    }

    if (!_isTracking && await _handleLocationPermission(context)) {
      // লোকেশন নিয়ে startWork কল করা
      try {
        Position initialPosition = await Geolocator.getCurrentPosition();
        _handleLocationUpdate(initialPosition); // বর্তমান Lat/Lon সেট করা হলো

        // startWork কল করা হচ্ছে
        await startWork(
          initialPosition.latitude,
          initialPosition.longitude,
        ); // ⭐ সংশোধন: deliveryId প্যারামিটার বাদ দেওয়া হলো
        _showMessage(context, 'ডিউটি এবং API কল শুরু হয়েছে: ট্র‍্যাকিং চালু');
      } catch (e) {
        print('Initial position or startWork error: $e');
        _showMessage(context, 'ট্র্যাকিং শুরু করতে সমস্যা হয়েছে।');
        _deliveryId = null;
        return; // ত্রুটি হলে ট্র্যাকিং শুরু হবে না
      }

      _isTracking = true;
      _currentStatus = DriverStatus.OnTheWay;
      notifyListeners();

      // প্রতি ১০ সেকেন্ডে লোকেশন পোল করার জন্য Timer সেট করা
      _locationUpdateTimer = Timer.periodic(
        const Duration(seconds: _updateIntervalSeconds),
        (Timer t) async {
          if (_isTracking) {
            try {
              Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              _handleLocationUpdate(position); // এখানে getRealTimeUpdate কল হবে
            } catch (e) {
              print('Error getting position via Timer: $e');
            }
          } else {
            _locationUpdateTimer?.cancel();
          }
        },
      );
    }
  }

  // ৭. ট্র্যাকিং বন্ধ করার ফাংশন ("End Trip") (অপরিবর্তিত)
  void _stopTracking() async {
    if (_isTracking) {
      _locationUpdateTimer?.cancel();
      _isTracking = false;
      _currentStatus = DriverStatus.Arrived;
      _deliveryId = null; // ডেলিভারি আইডি রিসেট করা

      // চূড়ান্ত অবস্থান নিয়ে সার্ভারে শেষ আপডেট
      try {
        Position finalPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _handleLocationUpdate(finalPosition); // final update call
      } catch (e) {
        print('Could not get final position: $e');
      }

      notifyListeners();
    }
  }

  // ৮. UI-তে ব্যবহারের জন্য পাবলিক ফাংশন (অপরিবর্তিত)
  void stopTracking(BuildContext context) {
    _stopTracking();
    _showMessage(context, 'ট্র‍্যাকিং বন্ধ হয়েছে: গন্তব্যে পৌঁছানো সম্পন্ন।');
  }

  // ৯. অ্যাপ বন্ধ হলে রিসোর্স ক্লিনআপ (অপরিবর্তিত)
  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  // ১০. API: Start Work (MODIFIED: deliveryId স্টেট থেকে নেওয়া হলো)
  Future<void> startWork(double startLat, double startLon) async {
    if (_deliveryId == null) return; // নিরাপত্তা চেক

    try {
      final url = Uri.parse(ApiEndpoints.initializedTracking(_deliveryId!));
      final token = await _tokenStorage.getToken();
      final response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "checkpoint1_lat": startLat,
          "checkpoint1_lon": startLon,
          "checkpoint2_lat": startLat + 0.01,
          "checkpoint2_lon": startLon + 0.01,
          "checkpoint3_lat": _destLatitude - 0.01,
          "checkpoint3_lon": _destLongitude - 0.01,
          "destination_lat": _destLatitude,
          "destination_lon": _destLongitude,
        }),
      );
      if (response.statusCode == 200) {
        print("Start Work API Success");
      } else {
        print("Start Work API Failed: ${response.body}");
      }
    } catch (error) {
      debugPrint("The error message in startWork: $error");
    }
  }

  // ১১. API: Real-Time Update (MODIFIED: deliveryId স্টেট থেকে নেওয়া হলো)
  Future<void> getRealTimeUpdate() async {
    if (_deliveryId == null) return; //

    try {
      final url = Uri.parse(ApiEndpoints.realTimeUpdate);
      final token = await _tokenStorage.getToken();

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "deliveryId": _deliveryId,
          "lat": _latitude,
          "lon": _longitude,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Real-Time Update API Success. Lat: $_latitude");
      } else {
        print("Real-Time Update API Failed: ${response.body}");
      }
    } catch (error) {
      debugPrint("The error message in getRealTimeUpdate: $error");
    }
  }
}
