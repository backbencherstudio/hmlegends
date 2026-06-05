import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/network/network_service.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
enum DriverStatus { Office, OnTheWay, Arrived }

class TrackingProvider extends ChangeNotifier {
  Timer? _locationUpdateTimer;
  bool _isTracking = false;
  DriverStatus _currentStatus = DriverStatus.Office;
  String? _deliveryId;

  void setDeliveryId(String deliveryId) {
    _deliveryId = deliveryId;
    notifyListeners();
  }

  String? get deliveryId => _deliveryId;

  static const int _updateIntervalSeconds = 10;

  double _latitude = 0.0;
  double _longitude = 0.0;
  String _lastUpdateTime = 'N/A';

  String _destinationAddress = 'N/A';
  double _destLatitude = 0.0;
  double _destLongitude = 0.0;

  List<Placemark> _addressSuggestions = [];

  final TokenStorage _tokenStorage = TokenStorage();

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

  /// ------------------ Show Message ------------------------------------------
  void _showMessage(String message) {
    Utils.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// -------------- Handle Location Permission --------------------------------
  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Location service is not enabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMessage('Location permission is denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showMessage('Location permission is permanently denied.');
      return false;
    }
    return true;
  }

  /// ------------------ Handle Location Update --------------------------------
  void _handleLocationUpdate(Position position) {
    _latitude = position.latitude;
    _longitude = position.longitude;
    _lastUpdateTime = DateTime.now().toLocal().toString().substring(11, 19);
    logger.d(
      'Sending data to server: Lat: $_latitude, Lon: $_longitude, Status: $_currentStatus, Time: $_lastUpdateTime',
    );

    if (_isTracking && _deliveryId != null) {
      getRealTimeUpdate();
    }

    notifyListeners();
  }

  /// --------- Search Address Suggestions -------------------------------------
  Future<void> searchAddressSuggestions(String input) async {
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
      logger.e("Error fetching suggestion: $e");
      _addressSuggestions = [];
    }
    notifyListeners();
  }

  /// --------------- Select Destination From Suggestion -----------------------
  void selectDestinationFromSuggestion(
    BuildContext context,
    Placemark selectedPlacemark,
  ) {
    final String address =
        '${selectedPlacemark.street}, ${selectedPlacemark.locality}, ${selectedPlacemark.country}';

    locationFromAddress(address)
        .then((locations) {
          if (locations.isNotEmpty) {
            _destLatitude = locations.first.latitude;
            _destLongitude = locations.first.longitude;

            _destinationAddress = address;

            _addressSuggestions = [];

            _showMessage('Destination address selected: $_destinationAddress');
            notifyListeners();
          } else {
            _showMessage('Location conversion error.');
          }
        })
        .catchError((e) {
          logger.e('Location conversion error: $e');
          _showMessage('Location conversion error.');
        });
  }

  /// ------------------ Start Tracking ----------------------------------------
  Future<void> startTracking(BuildContext context) async {
    if (_destinationAddress == 'N/A' ||
        (_destLatitude == 0.0 && _destLongitude == 0.0)) {
      _showMessage('Please select a destination address.');
      return;
    }

    if (_deliveryId == null || _deliveryId!.isEmpty) {
      _showMessage('No delivery ID found.');
      return;
    }

    if (!_isTracking && await _handleLocationPermission(context)) {
      try {
        Position initialPosition = await Geolocator.getCurrentPosition();
        _handleLocationUpdate(initialPosition);

        await startWork(initialPosition.latitude, initialPosition.longitude);
        _showMessage('Start Work API Success');
      } catch (e) {
        logger.e('Initial position or startWork error: $e');
        _showMessage('Initial position or startWork error.');
        _deliveryId = null;
        return;
      }

      _isTracking = true;
      _currentStatus = DriverStatus.OnTheWay;
      notifyListeners();

      _locationUpdateTimer = Timer.periodic(
        const Duration(seconds: _updateIntervalSeconds),
        (Timer t) async {
          if (_isTracking) {
            try {
              Position position = await Geolocator.getCurrentPosition(
                // ignore: deprecated_member_use
                desiredAccuracy: LocationAccuracy.high,
              );
              _handleLocationUpdate(position);
            } catch (e) {
              logger.e('Error getting position via Timer: $e');
            }
          } else {
            _locationUpdateTimer?.cancel();
          }
        },
      );
    }
  }

  /// --------------------- Stop Tracking --------------------------------------
  void _stopTracking() async {
    if (_isTracking) {
      _locationUpdateTimer?.cancel();
      _isTracking = false;
      _currentStatus = DriverStatus.Arrived;
      _deliveryId = null;

      try {
        Position finalPosition = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );
        _handleLocationUpdate(finalPosition); // final update call
      } catch (e) {
        logger.e('Could not get final position: $e');
      }

      notifyListeners();
    }
  }

  void stopTracking(BuildContext context) {
    _stopTracking();
    _showMessage('Tracking stopped.');
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  /// --------------------- Start Work -----------------------------------------
  Future<void> startWork(double startLat, double startLon) async {
    if (_deliveryId == null) return;

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
        logger.d("Start Work API Success");
      } else {
        logger.d("Start Work API Failed: ${response.body}");
      }
    } catch (error) {
      logger.e("The error message in startWork: $error");
    }
  }

  /// ---------------- Get Real-Time Update ------------------------------------
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
        logger.d("Real-Time Update API Success. Lat: $_latitude");
      } else {
        logger.d("Real-Time Update API Failed: ${response.body}");
      }
    } catch (error) {
      logger.e("The error message in getRealTimeUpdate: $error");
    }
  }
}
