import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String title, subtitle, label1, value1, iconPath;
  final String? label2, value2;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.label1,
    required this.value1,
    required this.iconPath,
    this.label2,
    this.value2,
  });

  @override
  Widget build(BuildContext context) {
    final hasSecondLine = label2 != null && value2 != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.headOfficeCardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Icon + Titles
          Row(
            children: [
              Image.asset(iconPath, width: 42.w, height: 42.h),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.authHeaderTextColor)),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.authHeaderTextColor)),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // Bottom labels
          if (hasSecondLine) ...[
            _row(label1, value1, true),
            SizedBox(height: 6.h),
            _row(label2!, value2!, false),
          ] else ...[
            SizedBox(height: 6.h),
            _row(label1, value1, true),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value, bool bold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: AppColors.authBodyTextColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500)),
        Text(value,
            style: TextStyle(
                color: AppColors.authBodyTextColor,
                fontSize: 14.sp,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }
}
