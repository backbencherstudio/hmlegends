import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../view_model/notification_admin/admin_notification_provider.dart';

class CustomAppbar extends StatefulWidget {
  final String title;
  final IconData back;
  final IconData notification;
  final String img;

  const CustomAppbar({
    super.key,
    required this.title,
    required this.back,
    required this.img,
    required this.notification,
  });

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          context.read<AdminNotificationProvider>().getAdminNotification();
        } catch (_) {}
      }
    });
  }

  void _handleTap(VoidCallback action) async {
    if (_isTapped) return;
    setState(() => _isTapped = true);
    action();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _isTapped = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(),
        child: Row(
          children: [
            IconButton(
              onPressed: () => _handleTap(() {
                Navigator.pop(context);
              }),
              icon: Icon(widget.back),
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: Color(0xff1D1F2C),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),

            Consumer<AdminNotificationProvider>(
              builder: (context, provider, child) {
                return GestureDetector(
                  onTap: () => _handleTap(() async {
                    await Navigator.pushNamed(
                      context,
                      RouteNames.adminNotificationScreen,
                    );
                    if (context.mounted) {
                      provider.getAdminNotification();
                    }
                  }),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(widget.notification, size: 25),
                      if (provider.unreadCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "${provider.unreadCount}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(width: 14.w),
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Image.asset(widget.img, width: 40, height: 40, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
