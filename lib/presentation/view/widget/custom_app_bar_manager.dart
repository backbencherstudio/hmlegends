import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/notification/view_model/manager_notification_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBarManager extends StatelessWidget
    implements PreferredSizeWidget {
  final String? profileImage;
  final String? backArrow;
  final int notificationCount;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const CustomAppBarManager({
    super.key,
    this.profileImage,
    this.backArrow,
    required this.notificationCount,
    this.onProfileTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
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
                  Row(
                    children: [
                      backArrow != null && backArrow!.isNotEmpty
                          ? GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
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
                  // Right Section
                  Row(
                    children: [
                      Consumer<ManagerNotificationProvider>(
                        builder: (context, provider, child) {
                          return GestureDetector(
                            onTap: () async {
                              await provider.getManagerNotification();
                              Navigator.pushNamed(
                                context,
                                RouteNames.managerNotificationScreen,
                              );
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
                        },
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap:
                            onProfileTap ??
                            () => Navigator.pushNamed(
                              context,
                              RouteNames.managerProfileScreen,
                            ),
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundImage:
                              profileImage != null && profileImage!.isNotEmpty
                                  ? NetworkImage(
                                    "${ApiEndpoints.baseUrl}/public/storage/avatar/$profileImage",
                                  )
                                  : AssetImage(AssetPaths.personIcon)
                                      as ImageProvider,
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
