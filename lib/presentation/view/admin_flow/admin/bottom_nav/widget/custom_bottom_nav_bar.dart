// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hmlegends/core/constant/app_colors.dart';
// import 'package:hmlegends/presentation/view_model/parent/bottom_nav_viewmodel.dart';
// import 'package:provider/provider.dart';
//
// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 85.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24.r),
//           topRight: Radius.circular(24.r),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20.r,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24.r),
//           topRight: Radius.circular(24.r),
//         ),
//         child: Consumer<BottomNavViewModel>(
//           builder: (context, bottomProvider,child) {
//             return BottomNavigationBar(
//               currentIndex: bottomProvider.currentIndex,
//               onTap: bottomProvider.updateIndex,
//               type: BottomNavigationBarType.fixed,
//               backgroundColor: Colors.white,
//               elevation: 0,
//               selectedItemColor: AppColors.headOfficeRadiusColor,
//               unselectedItemColor: AppColors.authBodyTextColor,
//               selectedFontSize: 13.sp,
//               unselectedFontSize: 13.sp,
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home_outlined),
//                   activeIcon: Icon(Icons.home, color: Colors.red),
//                   label: 'Home',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.show_chart_outlined),
//                   activeIcon: Icon(Icons.show_chart, color: Colors.red),
//                   label: 'Stock',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.inventory_2_outlined),
//                   activeIcon: Icon(Icons.inventory_2, color: Colors.red),
//                   label: 'Order',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.receipt_long_outlined),
//                   activeIcon: Icon(Icons.receipt_long, color: Colors.red),
//                   label: 'Invoice',
//                 ),
//               ],
//             );
//           }
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:provider/provider.dart';

import '../../../view_model/parent/bottom_nav_viewmodel.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
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
                  iconPath: AssetPaths.homeNavIcon,
                  activeIconPath: AssetPaths.homeNavIcon,
                  label: 'Home',
                  isActive: bottomProvider.currentIndex == 0,
                ),
                _buildBottomNavItem(
                  iconPath: AssetPaths.stockNavIcon,
                  activeIconPath: AssetPaths.stockNavIcon,
                  label: 'Stock',
                  isActive: bottomProvider.currentIndex == 1,
                ),
                _buildBottomNavItem(
                  iconPath: AssetPaths.orderNavIcon,
                  activeIconPath: AssetPaths.orderNavIcon,
                  label: 'Order',
                  isActive: bottomProvider.currentIndex == 2,
                ),
                _buildBottomNavItem(
                  iconPath: AssetPaths.invoiceNavIcon,
                  activeIconPath: AssetPaths.invoiceNavIcon,
                  label: 'Invoice',
                  isActive: bottomProvider.currentIndex == 3,
                ),
              ],
            );
          },
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
        colorFilter: ColorFilter.mode(
          AppColors.authBodyTextColor,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        activeIconPath,
        width: 25.w,
        height: 25.h,
        colorFilter: ColorFilter.mode(
          AppColors.headOfficeRadiusColor,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
