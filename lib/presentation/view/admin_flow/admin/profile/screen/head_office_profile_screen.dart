import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';

import '../widget/logout_dialog.dart';

class HeadOfficeProfileScreen extends StatelessWidget {
  const HeadOfficeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              icon: Icon(Icons.settings_outlined, size: 24.w),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.h, left: 2.w, right: 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            const _ProfileHeader(),
            SizedBox(height: 15.h),
            const _ProfileInfoTile(
              icon: Icons.phone_outlined,
              title: 'Phone Number',
              value: '+123-456-7890',
            ),
            Divider(indent: 15.w, endIndent: 15.w, color: Colors.grey.shade300),
            const _ProfileInfoTile(
              icon: Icons.mail_outline,
              title: 'Email',
              value: 'camwill056@gmail.com',
            ),
            Divider(indent: 15.w, endIndent: 15.w, color: Colors.grey.shade300),
            const _ProfileInfoTile(
              icon: Icons.location_on_outlined,
              title: 'Address',
              value: '2715 Ash Dr. San Jose, South\nDakota 83475',
            ),
            Divider(indent: 15.w, endIndent: 15.w, color: Colors.grey.shade300),
            _ProfileActionTile(
              icon: Icons.logout,
              title: 'Log out',
              isDestructive: true,
              onTap: () {
                logoutShowSubmitDialog(context);
              },
            ),
            Divider(indent: 15.w, endIndent: 15.w, color: Colors.grey.shade300),
            _ProfileActionTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              isDestructive: true,
              onTap: () {
                Navigator.pushNamed(context, RouteNames.headOfficeChangePasswordScreen);
              },
            ),
            Divider(indent: 15.w, endIndent: 15.w, color: Colors.grey.shade300),
            _ProfileActionTile(
              icon: Icons.info_outline,
              title: 'Change info',
              isDestructive: true,
              onTap: () {
                Navigator.pushNamed(context, RouteNames.headOfficeChangeInfoScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE20613),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: Image.asset(
                    AssetPaths.personIcon,
                    scale: 2.7,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 50.w, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: -5.h,
                  right: -5.w,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2.r),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: const Color(0xFFD32F2F),
                      size: 19.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              'Hamza Chowdhury',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Owner of Legends",
              style: TextStyle(
                color: const Color(0xFFF0F0F0),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87, size: 24.w),
          SizedBox(width: 15.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xff1D1F2C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF4A4C56),
                    fontWeight: FontWeight.w400,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive ? const Color(0xFFD32F2F) : Colors.black87;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? const Color(0xff4A4C56), size: 24.w),
            SizedBox(width: 15.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
