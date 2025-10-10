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
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              SizedBox(height: 100.h),
              Image.asset("assets/icons/orders.png", height: 95.h, width: 95.w),
              SizedBox(height: 30.h),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    },
  );
}
