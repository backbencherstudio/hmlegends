import 'package:flutter/material.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminNotificationScreen extends StatelessWidget {
  const AdminNotificationScreen({super.key});


  String formatTimestamp(String timestamp) {
    DateTime date = DateTime.parse(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final adminNotificationProvider = Provider.of<AdminNotificationProvider>(context);

    final notificationData =adminNotificationProvider.adminNotificationModel?.data ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Notifications'),
        backgroundColor:Colors.transparent,
        centerTitle: true,
      ),
      body: notificationData.isEmpty
          ? const Center(
        child: Text(
          'No notifications',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notificationData.length,
        separatorBuilder: (_, __) => const Divider(height: 20),
        itemBuilder: (context, index) {
          final notification = notificationData[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.sender?.name ?? "N/A",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.sender?.name ?? "N/A",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.sender?.name ?? "N/A",

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
