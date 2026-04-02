import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  /// ----------------- Format Time Stamp --------------------------------------
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
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Color(0xFF1D1F2C)),
        ),
        title: Text(
          "Admin Notification",
          style: TextStyle(
            fontSize: 20.sp,
            color: Color(0xFF1D1F2C),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xffFFF6F7),
        centerTitle: true,
      ),

      body:
          notificationData.isEmpty
              ? Center(
                child: Text(
                  'No notifications',
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
              )
              : ListView.separated(
                padding: EdgeInsets.all(16.r),
                itemCount: notificationData.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final n = notificationData[index];
                  final isRead = n.readAt != null;

                  return GestureDetector(
                    onTap: () {
                      if (!isRead && n.id == null) {
                        Provider.of<AdminNotificationProvider>(
                          context,
                          listen: false,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: isRead ? Colors.white : Color(0xffFFEDED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.notificationEvent?.text ?? 'No message',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            formatTimestamp(n.createdAt),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
