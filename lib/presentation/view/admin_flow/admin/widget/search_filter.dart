import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';

class SearchField extends  StatelessWidget {
  const SearchField({
    super.key, required this.hintText,
  });
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: AppColors.searchFieldBgColor,
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 50.w,
            right: 16.w,
            top: 14.h,
            bottom: 14.h,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 4.w),
            child: Icon(
              CupertinoIcons.search,
              color: AppColors.iconColor,
              size: 24.sp,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 44.w,
            minHeight: 48.h,
          ),
          hintText:hintText.isNotEmpty?hintText:'Search',
          hintStyle: AppTextStyles.hintText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}