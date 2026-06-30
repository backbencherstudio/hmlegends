import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:provider/provider.dart';

import '../../../admin_flow/admin/profile/screen/head_office_profile_screen.dart';
import '../../driver_home/driver_home_screen.dart';
import '../viewmodel/driver_bottom_nav_provider.dart';

class DriverBottomNavScreen extends StatefulWidget {
  const DriverBottomNavScreen({super.key});

  @override
  State<DriverBottomNavScreen> createState() => _DriverBottomNavScreenState();
}

class _DriverBottomNavScreenState extends State<DriverBottomNavScreen> {
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DriverBottomNavProvider>().updateIndex(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DriverHomeScreen(),
      HeadOfficeProfileScreen(),
    ];

    return Consumer<DriverBottomNavProvider>(
      builder: (context, nav, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (nav.currentIndex != 0) {
              nav.updateIndex(0);
              return;
            }

            final now = DateTime.now();
            final backButtonHasNotBeenPressedOrMaxTimeHasPassed =
                _lastPressedAt == null ||
                now.difference(_lastPressedAt!) > const Duration(seconds: 2);

            if (backButtonHasNotBeenPressedOrMaxTimeHasPassed) {
              _lastPressedAt = now;
              Utils.showToast(
                msg: "Press back again to exit the app",
                backgroundColor: Colors.black,
                textColor: Colors.white,
              );
              return;
            }

            await SystemNavigator.pop();
          },
          child: Scaffold(
            backgroundColor: AppColors.bgColor,
            body: pages[nav.currentIndex],
            bottomNavigationBar: const DriverBottomNavBar(),
          ),
        );
      },
    );
  }
}

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
          child: Consumer<DriverBottomNavProvider>(
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
                      iconPath: 'assets/icons/user.svg',
                      activeIconPath: 'assets/icons/user.svg',
                      label: 'Profile',
                      isActive: bottomProvider.currentIndex == 1,
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
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        activeIconPath,
        width: 25.w,
        height: 25.h,
        colorFilter: const ColorFilter.mode(AppColors.headOfficeRadiusColor, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}
