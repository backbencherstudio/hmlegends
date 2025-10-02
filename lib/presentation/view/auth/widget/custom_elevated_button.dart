import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final IconData? suffixIcon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? width;
  final double? height;
  final bool enabled;
  final double borderRadius;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    this.suffixIcon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = AppColors.onBoardingButtonTextColor,
    this.width,
    this.height,
    this.enabled = true,
    this.borderRadius = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withOpacity(0.5),
          disabledForegroundColor: foregroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (suffixIcon != null) ...[
              SizedBox(width: 8.w),
              Icon(
                suffixIcon,
                size: 18.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}