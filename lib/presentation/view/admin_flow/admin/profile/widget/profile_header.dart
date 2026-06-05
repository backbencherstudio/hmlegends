import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  final File? pickedImage;
  final String? imageUrl;
  final String fname;
  final String lname;
  final String occupation;
  final String phoneController;
  final String addressController;
  final VoidCallback onImagePick;

  const ProfileHeader({super.key, 
    this.pickedImage,
    this.imageUrl,
    required this.fname,
    required this.lname,
    required this.onImagePick,
    required this.occupation,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    Widget displayImage;

    //final provider = context.watch<ChangePasswordProvider>();

    if (pickedImage != null) {
      displayImage = Image.file(
        pickedImage!,
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      displayImage = Image.network(
        "${ApiEndpoints.baseUrl}/storage/avatar/$imageUrl",
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
      );
    } else {
      displayImage = Image.asset(
        AssetPaths.personIcon,
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE20613), Color(0xFFD91A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Center(
        child: Consumer<ChangePasswordProvider>(
          builder: (context, provider, child) {
            final name =
                "${provider.adminInfoModel?.data?.name ?? fname} ${provider.adminInfoModel?.data?.name ?? lname}";
            final occupation =
                provider.adminInfoModel?.data?.occupation ?? this.occupation;
            return Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(child: displayImage),
                    Positioned(
                      bottom: -4.h,
                      right: -4.w,
                      child: GestureDetector(
                        onTap: onImagePick,
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFFE20613),
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  occupation,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 15.sp,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
