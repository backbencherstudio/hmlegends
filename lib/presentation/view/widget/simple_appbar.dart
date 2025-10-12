// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hmlegends/core/constant/app_colors.dart';
// import 'package:hmlegends/core/constant/asset_path.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final String profileImage;
//   final int notificationCount;
//   final VoidCallback? onProfileTap;
//   final VoidCallback? onNotificationTap;
//
//   const CustomAppBar({
//     super.key,
//     required this.title,
//     required this.profileImage,
//     required this.notificationCount,
//     this.onProfileTap,
//     this.onNotificationTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       elevation: 1,
//       shadowColor: Colors.black26,
//       child: Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         child: SafeArea(
//           bottom: false,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Left Section
//               Row(
//                 children: [
//                   Image.asset(AssetPaths.headOfficeLogo, height: 38.h),
//                   SizedBox(width: 8.w),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//               // Right Section
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: onNotificationTap,
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Icon(CupertinoIcons.bell, size: 28.sp),
//                         if (notificationCount > 0)
//                           Positioned(
//                             right: 1.w,
//                             top: -7.h,
//                             child: Container(
//                               padding: EdgeInsets.all(3.w),
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFFB5050F),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Text(
//                                 '$notificationCount',
//                                 style: TextStyle(
//                                   fontSize: 11.sp,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 16.w),
//                   GestureDetector(
//                     onTap: onProfileTap,
//                     child: CircleAvatar(
//                       radius: 18.r,
//                       backgroundImage: AssetImage(profileImage),
//                     ),
//                   ),
//                 ],
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(75.h);
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';

class SimpleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String profileImage;
  final int notificationCount;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final String title;

  const SimpleAppbar({
    super.key,
    required this.profileImage,
    required this.notificationCount,
    this.onProfileTap,
    this.onNotificationTap,
    required this.title,
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
          // Main app bar content
          Container(
            color: AppColors.bgColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Section
                  Row(
                    spacing: 4,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  // Right Section
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onNotificationTap,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, RouteNames.notificationScreen);
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
                        onTap: onProfileTap,
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
          Container(height: 8.h, color: AppColors.bgColor),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}
