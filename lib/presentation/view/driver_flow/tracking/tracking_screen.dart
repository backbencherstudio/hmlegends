import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tracking_provider.dart'; // ধরুন provider ফাইলটি একই ফোল্ডারে আছে

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider-কে লিসেন করা হচ্ছে (Consumer ব্যবহার করে UI আপডেট)
    return Consumer<TrackingProvider>(
      builder: (context, tracker, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Driver Tracking'),
            // ট্র‍্যাকিং চালু থাকলে সবুজ, না হলে ধূসর ব্যাকগ্রাউন্ড
            backgroundColor:
                tracker.isTracking ? Colors.green.shade700 : Colors.blueGrey,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ১. স্ট্যাটাস ডিসপ্লে কার্ড
                _buildStatusCard(tracker),
                const SizedBox(height: 20),

                // ২. লোকেশন ডেটা ডিসপ্লে কার্ড
                _buildLocationCard(tracker),
                const Spacer(),

                // ৩. কন্ট্রোল বাটন
                // ট্র‍্যাকিং চালু থাকলে Stop, না হলে Start বাটন দেখানো হচ্ছে
                tracker.isTracking
                    ? _buildStopButton(context, tracker)
                    : _buildStartButton(context, tracker),
              ],
            ),
          ),
        );
      },
    );
  }

  // স্ট্যাটাস কার্ড তৈরি
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
            // বর্তমান অবস্থা দেখানো হচ্ছে
            _buildDataRow(
              'Current Position:',
              tracker.statusBangla,
              color:
                  tracker.currentStatus == DriverStatus.OnTheWay
                      ? Colors.green.shade700
                      : Colors.deepOrange.shade700,
            ),
            // ট্র‍্যাকিং স্ট্যাটাস দেখানো হচ্ছে
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

  // লোকেশন ডেটা কার্ড তৈরি
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
            // অক্ষাংশ (Latitude) দেখানো হচ্ছে
            _buildDataRow('Latitude:', tracker.latitude.toStringAsFixed(6)),
            // দ্রাঘিমাংশ (Longitude) দেখানো হচ্ছে
            _buildDataRow('Longitude:', tracker.longitude.toStringAsFixed(6)),
            // শেষ আপডেট সময় (প্রতি ১০ সেকেন্ডে পরিবর্তিত হবে)
            _buildDataRow('Last Update Time:', tracker.lastUpdateTime),
          ],
        ),
      ),
    );
  }

  // ডেটা রো তৈরি (লেবেল এবং ভ্যালু দেখানোর জন্য)
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

  // ডিউটি শুরু (Start Duty) বাটন
  Widget _buildStartButton(BuildContext context, TrackingProvider tracker) {
    return ElevatedButton.icon(
      // startTracking ফাংশনটি Timer সেট করে ট্র‍্যাকিং শুরু করবে
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

  // ট্র‍্যাকিং বন্ধ (End Trip) বাটন
  Widget _buildStopButton(BuildContext context, TrackingProvider tracker) {
    return ElevatedButton.icon(
      // stopTracking ফাংশনটি Timer বন্ধ করে ট্র‍্যাকিং শেষ করবে
      onPressed: () => tracker.stopTracking(context),
      icon: const Icon(Icons.stop),
      label: const Text(
        'ট্র‍্যাকিং বন্ধ করুন (End Trip)',
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}
