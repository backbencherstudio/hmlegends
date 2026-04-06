import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/notification/view_model/manager_notification_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManagerNotificationScreen extends StatefulWidget {
  const ManagerNotificationScreen({super.key});

  static const String routeName = '/managerNotifications';

  @override
  State<ManagerNotificationScreen> createState() =>
      _ManagerNotificationScreenState();
}

class _ManagerNotificationScreenState extends State<ManagerNotificationScreen> {
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
    final provider = Provider.of<ManagerNotificationProvider>(context);
    final notificationData = provider.managerNotificationModel?.data ?? [];

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
          "Manager Notification",
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No notifications Found',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
                        Provider.of<ManagerNotificationProvider>(
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
