import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F7),
          borderRadius: BorderRadius.circular(32.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 24.w, height: 24.h),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(
                color: Color(0xff404148),
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
