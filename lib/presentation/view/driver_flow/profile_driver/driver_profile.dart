import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/driver_flow/model_view/driver_profile_screen_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/api_endpoint.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final driverProvider = Provider.of<DriverProfileScreenProvider>(
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      );
      driverProvider.checkMeDriver();
    });
  }

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are you sure you want to log out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                          context,
                          RouteNames.loginScreen,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xffE20613),
                        side: const BorderSide(color: Color(0xffE20613)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text("Log me out"),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE20613),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text("Stay logged in"),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driverProvider = Provider.of<DriverProfileScreenProvider>(context);
    final user = driverProvider.checkMeModelDriver?.data;

    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, size: 24.w),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          children: [
            SizedBox(height: 15.h),

            _ProfileHeader(
              name: "${user?.firstName ?? ''} ${user?.lastName ?? ''}",
              occupation: user?.occupation ?? "Driver",
              avatarUrl: user?.avatar,
            ),

            SizedBox(height: 15.h),

            _ProfileInfoTile(
              icon: Icons.phone_outlined,
              title: "Phone Number",
              value: user?.phoneNumber ?? "",
            ),
            Divider(indent: 20.w, endIndent: 20.w),
            _ProfileInfoTile(
              icon: Icons.mail_outline,
              title: "Email",
              value: user?.email ?? "",
            ),

            Divider(indent: 20.w, endIndent: 20.w),
            _ProfileInfoTile(
              icon: Icons.location_on_outlined,
              title: "Address",
              value: user?.address ?? "",
            ),

            Divider(indent: 20.w, endIndent: 20.w),

            /// Actions
            // _ProfileActionTile(
            //   icon: Icons.lock_outline,
            //   title: "Change Password",
            //   onTap: () =>
            //       Navigator.pushNamed(context, RouteNames.changePassword),
            // ),
            // Divider(indent: 20.w, endIndent: 20.w),
            _ProfileActionTile(
              icon: Icons.info_outline,
              title: "Change Info",
              onTap:
                  () =>
                      Navigator.pushNamed(context, RouteNames.changeInfoDriver),
            ),

            Divider(indent: 20.w, endIndent: 20.w),

            _ProfileActionTile(
              icon: Icons.logout,
              title: "Log out",
              isDestructive: true,
              onTap: () => _showSubmitDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ---------------- PROFILE HEADER ----------------
//

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String occupation;
  final String? avatarUrl;

  const _ProfileHeader({
    required this.name,
    required this.occupation,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE20613),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipOval(
                child:
                    avatarUrl != null && avatarUrl!.isNotEmpty
                        ? Image.network(
                          "${ApiEndpoints.baseUrl}/storage/avatar/$avatarUrl",
                          width: 100.w,
                          height: 100.w,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          'assets/images/panda.jpeg',
                          width: 90.w,
                          height: 90.w,
                          fit: BoxFit.cover,
                        ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 15.r,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xffE20613),
                    size: 18.w,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Text(
            name.isNotEmpty ? name : "No Name",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            occupation,
            style: TextStyle(color: Colors.white70, fontSize: 15.sp),
          ),
        ],
      ),
    );
  }
}

//
// ---------------- PROFILE INFO TILE ----------------
//

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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87, size: 24.w),
          SizedBox(width: 15.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// ---------------- PROFILE ACTION TILE ----------------
//

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive ? const Color(0xffE20613) : Colors.black87;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 22.w),
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
