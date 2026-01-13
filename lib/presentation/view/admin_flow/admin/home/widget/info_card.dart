import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String label1;
  final String value1;
  final String iconPath;

  final String? label2;
  final String? value2;

  final VoidCallback? onTaps;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.label1,
    required this.value1,
    required this.iconPath,
    this.label2,
    this.value2,
    this.onTaps,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSecondLine = label2 != null && value2 != null;

    return GestureDetector(
      onTap: onTaps,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.headOfficeCardBorderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title == "User"
                    ? Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffFCE6E7),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        iconPath,
                        width: 30.w,
                        height: 30.h,
                        color: title == "User" ? Colors.red : null,
                      ),
                    )
                    : Image.asset(
                      iconPath,
                      width: 42.w,
                      height: 42.h,
                      color: title == "User" ? Colors.red : null,
                    ),
                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.authHeaderTextColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.authHeaderTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            /// LABEL + VALUES
            _row(label1, value1, true),

            if (hasSecondLine) ...[
              SizedBox(height: 6.h),
              _row(label2!, value2!, false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, bool bold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color:
                label == "See All Pending"
                    ? Colors.black
                    : AppColors.authBodyTextColor,
            fontSize: 12.sp,
            fontWeight:
                label == "See All Pending" ? FontWeight.bold : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.authBodyTextColor,
            fontSize: 14.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
