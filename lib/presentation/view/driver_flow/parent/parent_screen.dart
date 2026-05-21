import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/profile/screen/head_office_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import '../driver_screen.dart';
import '../tracking/tracking_screen.dart';

class DriverBottomNavBar extends StatelessWidget {
  const DriverBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      top: false,
      bottom: false,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20.r,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          child: Consumer<BottomNavViewModel>(
            builder: (context, bottomProvider, child) {
              return BottomNavigationBar(
                currentIndex: bottomProvider.currentIndex,
                onTap: bottomProvider.updateIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0,
                selectedItemColor: AppColors.headOfficeRadiusColor,
                unselectedItemColor: AppColors.authBodyTextColor,
                selectedFontSize: 13.sp,
                unselectedFontSize: 13.sp,
                items: [
                  _buildBottomNavItem(
                    iconPath: 'assets/icons/mynaui_home.svg',
                    activeIconPath: 'assets/icons/mynaui_home.svg',
                    label: 'Home',
                    isActive: bottomProvider.currentIndex == 0,
                  ),
                  _buildBottomNavItem(
                    iconPath: 'assets/icons/mynaui_home.svg',
                    activeIconPath: 'assets/icons/mynaui_home.svg',
                    label: 'Tacking',
                    isActive: bottomProvider.currentIndex == 1,
                  ),
                  _buildBottomNavItem(
                    iconPath: 'assets/icons/user.svg',
                    activeIconPath: 'assets/icons/user.svg',
                    label: 'Profile',
                    isActive: bottomProvider.currentIndex == 2,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required String iconPath,
    required String activeIconPath,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: 25.w,
        height: 25.h,
        color: Colors.black54, // Unselected color
      ),
      activeIcon: SvgPicture.asset(
        activeIconPath,
        width: 25.w,
        height: 25.h,
        color: AppColors.headOfficeRadiusColor, // Selected color
      ),
      label: label,
    );
  }
}

class DriverBranchParentScreen extends StatelessWidget {
  const DriverBranchParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DriverScreen(),
      TrackingScreen(),
      HeadOfficeProfileScreen(),
    ];

    return Consumer<BottomNavViewModel>(
      builder: (context, nav, child) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: pages[nav.currentIndex],
          bottomNavigationBar: const DriverBottomNavBar(),
        );
      },
    );
  }
}
