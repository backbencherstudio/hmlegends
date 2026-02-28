
import 'package:flutter/material.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../../../core/route/route_names.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void SuccessDeleteStock(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(dialogContext).pop();
        Navigator.of(dialogContext).pushReplacementNamed(
          RouteNames.mainWrapper,
        );
      });

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Container(
          width: 335.w,
          height: 451.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetPaths.successfulIcon,
                height: 100.h,
                width: 100.w,
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
