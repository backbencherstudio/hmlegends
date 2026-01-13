import 'package:flutter/material.dart';
import 'package:hmlegends/core/services/fm_token_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../view_model/notification_admin/admin_notification_provider.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});

  static const String routeName = '/adminNotifications';

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
  String _fcmToken = "";

  @override
  void initState() {
    super.initState();
    _loadFcmToken();
  }

  Future<void> _loadFcmToken() async {
    final token = await FcmTokenStorage().getFcmToken();
    setState(() {
      _fcmToken = token ?? "";
    });
  }

  String formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminNotificationProvider>(context);
    final notificationData = provider.adminNotificationModel?.data ?? [];

    return Scaffold(
      backgroundColor: Color(0xffFFF6F7),
      appBar: AppBar(
        surfaceTintColor: Color(0xffFFF6F7),
        elevation: 0,
        title: Text("Admin Notification"),
        backgroundColor: Color(0xffFFF6F7),
        centerTitle: true,
      ),

      body:
          notificationData.isEmpty
              ? const Center(
                child: Text(
                  'No notifications',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notificationData.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final n = notificationData[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xffFFEDED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n.sender?.name ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          n.notificationEvent?.text ?? 'No message',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatTimestamp(n.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
