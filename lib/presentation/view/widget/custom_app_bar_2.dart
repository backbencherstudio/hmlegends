import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/api_endpoint.dart';
import '../../../core/route/route_names.dart';
import '../admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import '../admin_flow/view_model/notification_admin/admin_notification_provider.dart';

class CustomAppBarTwo extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImage;
  final int notificationCount;
  final Color colorMain;
  final Color colorSpace;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBackTap;
  final bool useBottomNavBack;
  final bool? isIconPresent;

  const CustomAppBarTwo({
    super.key,
    required this.title,
    this.profileImage,
    required this.notificationCount,
    this.onProfileTap,
    this.onNotificationTap,
    this.onBackTap,
    required this.colorMain,
    required this.colorSpace,
    this.useBottomNavBack = false,
    this.isIconPresent = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  State<CustomAppBarTwo> createState() => _CustomAppBarTwoState();
}

class _CustomAppBarTwoState extends State<CustomAppBarTwo> {
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
    return Material(
      color: widget.colorMain,
      elevation: 1,
      shadowColor: Colors.black26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main app bar content
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: back arrow + title
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isIconPresent == true)
                        GestureDetector(
                          onTap:
                              () => _handleTap(
                                widget.onBackTap ??
                                    () => _handleBackNavigation(context),
                              ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 24.sp,
                            color: AppColors.authHeaderTextColor,
                          ),
                        ),
                      SizedBox(width: 8.w),
                      Text(widget.title, style: AppTextStyles.appHeaderText),
                    ],
                  ),

                  // Right: notification + profile
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildNotificationIcon(context),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap:
                            () => _handleTap(
                              widget.onProfileTap ??
                                  () => Navigator.pushNamed(
                                    context,
                                    RouteNames.headOfficeProfileScreen,
                                  ),
                            ),
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundImage:
                              (widget.profileImage != null &&
                                      widget.profileImage!.isNotEmpty &&
                                      !widget.profileImage!.startsWith(
                                        'assets/',
                                      ))
                                  ? NetworkImage(
                                    '${ApiEndpoints.baseUrl}/public/storage/avatar/${widget.profileImage}',
                                  )
                                  : const AssetImage(
                                        'assets/icons/profile_icon.png',
                                      )
                                      as ImageProvider,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 8.h, color: widget.colorSpace),
        ],
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    if (widget.useBottomNavBack) {
      // Navigate to home using bottom nav
      _navigateToHome(context);
    } else {
      // Use normal back navigation
      Navigator.pop(context);
    }
  }

  void _navigateToHome(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavViewModel>(
      context,
      listen: false,
    );
    bottomNavProvider.updateIndex(0);
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return GestureDetector(
      onTap:
          () => _handleTap(
            widget.onNotificationTap ??
                () async {
                  await Navigator.pushNamed(
                    context,
                    RouteNames.adminNotificationScreen,
                  );
                  if (context.mounted) {
                    context.read<AdminNotificationProvider>().getAdminNotification();
                  }
                },
          ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(CupertinoIcons.bell, size: 28.sp),
          if (widget.notificationCount > 0)
            Positioned(
              right: 1.w,
              top: -7.h,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFB5050F),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.notificationCount}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
