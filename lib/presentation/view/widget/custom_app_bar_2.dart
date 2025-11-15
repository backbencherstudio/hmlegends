// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hmlegends/core/constant/app_colors.dart';
// import 'package:hmlegends/core/constant/app_text_styles.dart';
// import 'package:hmlegends/presentation/view_model/parent/bottom_nav_viewmodel.dart';
// import 'package:provider/provider.dart';
//
// import '../../../core/route/route_names.dart';
//
// class CustomAppBarTwo extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final String profileImage;
//   final int notificationCount;
//   final Color colorMain;
//   final Color colorSpace;
//   final VoidCallback? onProfileTap;
//   final VoidCallback? onNotificationTap;
//   final VoidCallback? onBackTap;
//
//   const CustomAppBarTwo({
//     super.key,
//     required this.title,
//     required this.profileImage,
//     required this.notificationCount,
//     this.onProfileTap,
//     this.onNotificationTap,
//     this.onBackTap,
//     required this.colorMain,
//     required this.colorSpace,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: colorMain,
//       elevation: 1,
//       shadowColor: Colors.black26,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Main app bar content
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//             child: SafeArea(
//               bottom: false,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Left Section with back arrow
//                   Row(
//                     children: [
//                      // Back arrow icon
//                       GestureDetector(
//                         onTap: onBackTap ?? () => _navigateToHome(context),
//                         child: Icon(
//                           Icons.arrow_back_ios,
//                           size: 20.sp,
//                           color: AppColors.authHeaderTextColor,
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Text(title, style: AppTextStyles.appHeaderText),
//                     ],
//                   ),
//                   // Right Section
//                   Row(
//                     children: [
//                       _buildNotificationIcon(context),
//                       SizedBox(width: 20.w),
//                       GestureDetector(
//                         onTap:
//                             onProfileTap ??
//                             () => Navigator.pushNamed(
//                               context,
//                               RouteNames.headOfficeProfileScreen,
//                             ),
//                         child: CircleAvatar(
//                           radius: 18.r,
//                           backgroundImage: AssetImage(profileImage),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(height: 8.h, color: colorSpace),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToHome(BuildContext context) {
//     final bottomNavProvider = Provider.of<BottomNavViewModel>(
//       context,
//       listen: false,
//     );
//     bottomNavProvider.updateIndex(0);
//   }
//
//   Widget _buildNotificationIcon(BuildContext context) {
//     return GestureDetector(
//       onTap:
//           onNotificationTap ??
//           () {
//             Navigator.pushNamed(context, RouteNames.notificationScreen);
//           },
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Icon(CupertinoIcons.bell, size: 28.sp),
//           if (notificationCount > 0)
//             Positioned(
//               right: 1.w,
//               top: -7.h,
//               child: Container(
//                 padding: EdgeInsets.all(3.w),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFB5050F),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Text(
//                   '$notificationCount',
//                   style: TextStyle(
//                     fontSize: 11.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(64.h);
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/presentation/view_model/parent/bottom_nav_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../core/route/route_names.dart';

class CustomAppBarTwo extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String profileImage;
  final int notificationCount;
  final Color colorMain;
  final Color colorSpace;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBackTap;
  final bool useBottomNavBack; // Add this parameter

  const CustomAppBarTwo({
    super.key,
    required this.title,
    required this.profileImage,
    required this.notificationCount,
    this.onProfileTap,
    this.onNotificationTap,
    this.onBackTap,
    required this.colorMain,
    required this.colorSpace,
    this.useBottomNavBack = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorMain,
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
                  // Left Section with back arrow
                  Row(
                    children: [
                      // Back arrow icon
                      GestureDetector(
                        onTap: onBackTap ?? () => _handleBackNavigation(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20.sp,
                          color: AppColors.authHeaderTextColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(title, style: AppTextStyles.appHeaderText),
                    ],
                  ),
                  // Right Section
                  Row(
                    children: [
                      _buildNotificationIcon(context),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap:
                        onProfileTap ??
                                () => Navigator.pushNamed(
                              context,
                              RouteNames.headOfficeProfileScreen,
                            ),
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundImage: AssetImage(profileImage),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 8.h, color: colorSpace),
        ],
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    if (useBottomNavBack) {
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
      onNotificationTap ??
              () {
            Navigator.pushNamed(context, RouteNames.notificationScreen);
          },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(CupertinoIcons.bell, size: 28.sp),
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}