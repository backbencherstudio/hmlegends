import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widget/logout_dialog.dart';
import '../../../../../../core/constant/api_endpoint.dart';
import '../../../view_model/profile/change_pass_provider.dart';

class HeadOfficeProfileScreen extends StatelessWidget {
  const HeadOfficeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChangePasswordProvider>(context);

    return FutureBuilder(
      future: provider.adminCheckMe(),
      builder: (context, snapshot) {
        final data = provider.adminInfoModel?.data;

        final String name = data?.name ?? "Not Found Name";
        final String occupation = data?.occupation ?? "Not Found Occupation";
        final String phone = data?.phoneNumber ?? "Not Found Number";
        final String address = data?.address ?? "Not Found Address";
        final String? avatar = data?.avatar;

        return Scaffold(
          backgroundColor: const Color(0xffFFF6F7),

          /// --------------------- App Bar ------------------------------------
          appBar: CustomAppBar(
            profileImage: data?.avatar,
            notificationCount: 4,
          ),

          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20.h, left: 2.w, right: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                /// ----------- Name / Occupation / Avatar ---------------------
                _ProfileHeader(
                  name: name,
                  occupation: occupation,
                  avatar: avatar,
                ),

                SizedBox(height: 16.h),

                ///------------------ Phone Number / Email / Address -----------
                _ProfileInfoTile(
                  icon: Icons.phone_outlined,
                  title: 'Phone Number',
                  value: phone,
                ),
                Divider(
                  indent: 15.w,
                  endIndent: 15.w,
                  color: Colors.grey.shade300,
                ),

                _ProfileInfoTile(
                  icon: Icons.mail_outline,
                  title: 'Email',
                  value: data?.email ?? "Not Found Email",
                ),
                Divider(
                  indent: 15.w,
                  endIndent: 15.w,
                  color: Colors.grey.shade300,
                ),

                _ProfileInfoTile(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  value: address,
                ),

                Divider(
                  indent: 15.w,
                  endIndent: 15.w,
                  color: Colors.grey.shade300,
                ),

                _ProfileActionTile(
                  icon: Icons.logout,
                  title: 'Log out',
                  isDestructive: true,
                  onTap: () => logoutShowSubmitDialog(context),
                ),

                Divider(
                  indent: 15.w,
                  endIndent: 15.w,
                  color: Colors.grey.shade300,
                ),

                _ProfileActionTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.headOfficeChangePasswordScreen,
                    );
                  },
                ),
                Divider(
                  indent: 15.w,
                  endIndent: 15.w,
                  color: Colors.grey.shade300,
                ),

                _ProfileActionTile(
                  icon: Icons.info_outline,
                  title: 'Change info',
                  isDestructive: true,
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        RouteNames.headOfficeChangeInfoScreen,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String occupation;
  final String? avatar;

  _ProfileHeader({
    required this.name,
    required this.occupation,
    required this.avatar,
  });

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Handle the selected image (e.g., upload to server or update UI)
      context.read<ChangePasswordProvider>().adminCheckMe();
    }
  }

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
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            ClipOval(
              child: GestureDetector(
                onTap: () => _pickImage(context),
                child:
                    avatar != null && avatar!.isNotEmpty
                        ? Image.network(
                          "${ApiEndpoints.baseUrl}/storage/avatar/$avatar",
                          width: 90.w,
                          height: 90.w,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          AssetPaths.personIcon,
                          width: 90.w,
                          height: 90.w,
                          fit: BoxFit.cover,
                        ),
              ),
            ),

            SizedBox(height: 15.h),

            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              occupation,
              style: TextStyle(color: const Color(0xFFF0F0F0), fontSize: 16.sp),
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
          Icon(icon, color: Color(0xFF4A4C56), size: 24.w),
          SizedBox(width: 16.w),
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
                    fontWeight: FontWeight.w400,
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
    final textColor = isDestructive ? const Color(0xFFD32F2F) : Colors.black87;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Row(
          children: [
            Icon(icon, color: Color(0xff4A4C56), size: 24.w),
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
