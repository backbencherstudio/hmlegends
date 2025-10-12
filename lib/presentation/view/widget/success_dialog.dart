import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';

void showSuccessDialog(BuildContext context, Function onDelete, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Container(
          width: 335.w,
          height: 451.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 50.w,vertical: 40.h),
            child: Column(
              children: [
                SizedBox(height: 100.h),
                Image.asset(AssetPaths.successfulIcon, height: 100.h, width: 100.w),
                SizedBox(height: 50.h),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
