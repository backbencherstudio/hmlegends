import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/route/route_names.dart';

import '../../../core/constant/api_endpoint.dart';

/// Defines the type of navigation to perform when back button is tapped
enum NavigationType {
  pop,
  pushNamed,
  pushReplacementNamed,
  popUntilFirst,
  none,
}

class SimpleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String profileImage;
  final int notificationCount;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  /// Determines the navigation behavior of the back button
  final NavigationType navigationType;

  /// Route path used when [navigationType] = pushNamed / pushReplacementNamed
  final String? navigationPath;

  /// Optional callback if you want to override all navigation
  final VoidCallback? customNavigationAction;

  const SimpleAppbar({
    super.key,
    required this.title,
    required this.profileImage,
    required this.notificationCount,
    this.onProfileTap,
    this.onNotificationTap,
    this.navigationType = NavigationType.pop,
    this.navigationPath,
    this.customNavigationAction,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 1,
      shadowColor: Colors.black26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: AppColors.bgColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 👇 Left Section: Back button (optional) + title
                  Row(
                    spacing: 4,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Color(0xFF1D1F2C),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),

                  // 👇 Right Section: Notification + Profile
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onNotificationTap,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.adminNotificationScreen,
                                );
                              },
                              child: Icon(CupertinoIcons.bell, size: 28.sp),
                            ),
                            if (notificationCount > 0)
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
                                    '$notificationCount',
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
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.headOfficeProfileScreen,
                          );
                        },
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundImage: NetworkImage(
                            "${ApiEndpoints.baseUrl}/storage/avatar/$profileImage",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 8.h, color: AppColors.bgColor),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}
