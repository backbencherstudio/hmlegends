// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hmlegends/core/constant/app_colors.dart';
//
// class OrderSummaryCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final bool isHighlighted;
//   final bool isWide;
//
//   const OrderSummaryCard({
//     super.key,
//     required this.title,
//     required this.value,
//     this.isHighlighted = false,
//     this.isWide = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: isWide ? 165.w : 95.w,
//       height: 100.h,
//       padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.r),
//         border: Border.all(
//           color: isHighlighted ? Colors.redAccent : Colors.transparent,
//           width: 1.2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 3,
//             offset: const Offset(1, 1),
//           )
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.w600,
//               color: isHighlighted ? Colors.black : Colors.black,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: AppColors.authBodyTextColor,fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';

class InvoiceSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isHighlighted;
  final bool isWide;

  const InvoiceSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.isHighlighted = false,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWide ? double.infinity : null,
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isHighlighted ? Colors.redAccent : Colors.transparent,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(1, 1),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: isHighlighted ? Colors.black : Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 4.h),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.authBodyTextColor,
                  fontWeight: FontWeight.w500
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}