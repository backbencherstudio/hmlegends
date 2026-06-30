// Old non-working bottom nav removed

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:provider/provider.dart';

import '../../admin_flow/view_model/parent/bottom_nav_viewmodel.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

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
              color: Colors.black.withValues(alpha: 0.08),
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
                      iconPath: 'assets/icons/lsicon_place-order-outline.svg',
                      activeIconPath: 'assets/icons/lsicon_place-order-outline.svg',
                      label: 'Orders',
                      isActive: bottomProvider.currentIndex == 1,
                    ),
                    _buildBottomNavItem(
                      iconPath: 'assets/icons/arcticons_zoho-invoice.svg',
                      activeIconPath: 'assets/icons/arcticons_zoho-invoice.svg',
                      label: 'Invoices',
                      isActive: bottomProvider.currentIndex == 2,
                    ),
                    _buildBottomNavItem(
                      iconPath: 'assets/icons/user.svg',
                      activeIconPath: 'assets/icons/user.svg',
                      label: 'Profile',
                      isActive: bottomProvider.currentIndex == 3,
                    ),
                  ],
                );
              }
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
        colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        activeIconPath,
        width: 25.w,
        height: 25.h,
        colorFilter: ColorFilter.mode(AppColors.headOfficeRadiusColor, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}