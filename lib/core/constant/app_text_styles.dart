import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';

class AppTextStyles {
  static TextStyle authHeadline = TextStyle(
    fontSize: 18.sp,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w500,
    color: AppColors.authHeaderTextColor,
  );

  static TextStyle authBodyText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.authBodyTextColor,
  );

  static TextStyle hintText= TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.authBodyTextColor,
  );

  static TextStyle labelText = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.authHeaderTextColor,
  );

  static TextStyle appHeaderText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Color(0xFF1D1F2C),
  );

// Add more styles as needed
}