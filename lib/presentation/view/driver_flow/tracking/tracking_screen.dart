import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import '../../admin_flow/view_model/profile/change_pass_provider.dart';
import 'tracking_provider.dart';
import 'package:geocoding/geocoding.dart';

// StatefulWidget
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late TextEditingController _addressController;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialLoad) {
      final tracker = Provider.of<TrackingProvider>(context, listen: false);
      if (tracker.destinationAddress != 'N/A') {
        _addressController.text = tracker.destinationAddress;
      }
      _isInitialLoad = false;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    return Consumer<TrackingProvider>(
      builder: (context, tracker, child) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: CustomAppBar(
            profileImage: data?.avatar,
            notificationCount: notificationProvider.unreadCount,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDestinationSearch(context, tracker),
                const SizedBox(height: 10),

                _buildDestinationCard(tracker),
                const SizedBox(height: 20),

                _buildStatusCard(tracker),
                const SizedBox(height: 20),

                _buildLocationCard(tracker),
                const SizedBox(height: 30),

                _buildControlButtons(context, tracker),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDestinationSearch(
    BuildContext context,
    TrackingProvider tracker,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addressController,
                onChanged: (input) {
                  tracker.searchAddressSuggestions(input);
                },
                decoration: InputDecoration(
                  hintText: 'Search Destination Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            ElevatedButton(
              onPressed: () {
                tracker.searchAddressSuggestions(_addressController.text);
                FocusScope.of(context).unfocus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ],
        ),

        if (tracker.addressSuggestions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 150),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tracker.addressSuggestions.length,
              itemBuilder: (context, index) {
                final Placemark suggestion = tracker.addressSuggestions[index];
                final String fullAddress =
                    '${suggestion.street}, ${suggestion.locality}, ${suggestion.country}';

                return ListTile(
                  title: Text(
                    fullAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: const Icon(Icons.location_on),
                  onTap: () {
                    tracker.selectDestinationFromSuggestion(
                      context,
                      suggestion,
                    );
                    _addressController.text = fullAddress;
                    FocusScope.of(context).unfocus();
                    _addressController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _addressController.text.length),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDestinationCard(TrackingProvider tracker) {
    return Card(
      elevation: 2,
      color: Colors.yellow.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Destination',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(),
            _buildDataRow(
              'Address:',
              tracker.destinationAddress.length > 30
                  ? '${tracker.destinationAddress.substring(0, 27)}...'
                  : tracker.destinationAddress,
              color: Colors.black87,
            ),
            _buildDataRow(
              'Lat/Lon:',
              '${tracker.destLatitude.toStringAsFixed(4)} / ${tracker.destLongitude.toStringAsFixed(4)}',
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(TrackingProvider tracker) {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(),
            _buildDataRow(
              'Current Position:',
              tracker.statusBangla,
              color:
                  tracker.currentStatus == DriverStatus.OnTheWay
                      ? Colors.green.shade700
                      : Colors.deepOrange.shade700,
            ),
            _buildDataRow(
              'Tracking:',
              tracker.isTracking ? 'চালু ✅' : 'Stop ❌',
              color: tracker.isTracking ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(TrackingProvider tracker) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Location Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildDataRow('Latitude:', tracker.latitude.toStringAsFixed(6)),
            _buildDataRow('Longitude:', tracker.longitude.toStringAsFixed(6)),
            _buildDataRow('Last Update Time:', tracker.lastUpdateTime),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context, TrackingProvider tracker) {
    if (tracker.isTracking) {
      return ElevatedButton.icon(
        onPressed: () => tracker.stopTracking(context),
        icon: const Icon(Icons.stop),
        label: const Text(
          'Off Tracking (End Trip)',
          style: TextStyle(fontSize: 18, color: Color(0xffFFFFFF)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600, //
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () => tracker.startTracking(context),
        icon: const Icon(Icons.play_arrow),
        label: const Text(
          'Start Duty (Start Duty)',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      );
    }
  }
}
