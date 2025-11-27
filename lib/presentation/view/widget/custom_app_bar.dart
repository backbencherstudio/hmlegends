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
import 'package:provider/provider.dart';

import '../../../core/constant/api_endpoint.dart';
import '../admin_flow/view_model/profile/change_pass_provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? backArrow;
  final int notificationCount;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const CustomAppBar({
    super.key,
    this.backArrow,
    required this.notificationCount,
    this.onProfileTap,
    this.onNotificationTap,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(64.h);
}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ChangePasswordProvider>().adminCheckMe();
    });


  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();
    final avatar = provider.adminInfoModel?.data?.avatarUrl;
  debugPrint('----------------------------------- $avatar');

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
                  Row(
                    children: [
                      widget.backArrow != null && widget.backArrow!.isNotEmpty
                          ? GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          "assets/images/back_arrow.png",
                          height: 38.h,
                        ),
                      )
                          : Image.asset(
                        AssetPaths.headOfficeLogo,
                        height: 38.h,
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),

                  /// Right Section
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, RouteNames.notificationScreen),
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
                      ),

                      SizedBox(width: 20.w),

                      /// Profile Avatar
                      GestureDetector(
                        onTap: widget.onProfileTap ??
                                () => Navigator.pushNamed(
                                context, RouteNames.headOfficeProfileScreen),
                        child: ClipOval(
                          child:Image.network(
                            avatar ?? '',
                            width: 30.w,
                            height: 30.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Image.asset(
                                AssetPaths.personIcon,
                                width: 30.w,
                                height: 30.w,
                                fit: BoxFit.cover,
                              );
                            },
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


}
