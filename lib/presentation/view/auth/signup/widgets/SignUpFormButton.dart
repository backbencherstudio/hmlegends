import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';

class SignUpFormButton extends StatelessWidget {
  const SignUpFormButton({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    required this.image,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? color;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.authTextFormFieldFillColor,
          borderRadius: BorderRadius.circular(30.sp),
          border: Border.all(color: AppColors.authTextFormFieldBorderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 20.w,
              height: 20.h,
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF4A4C56),
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}