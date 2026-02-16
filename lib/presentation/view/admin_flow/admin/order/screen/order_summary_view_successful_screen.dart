import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../../auth/widget/auth_button.dart';
import '../../../../widget/custom_app_bar_2.dart';

class OrderSummaryViewSuccessfulScreen extends StatelessWidget {
  const OrderSummaryViewSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderItems = [
      {
        "name": "Peri Chicken Wrap",
        "qty": 20,
        "image": AssetPaths.orderSummaryIcon1,
      },
      {
        "name": "Billy's Special",
        "qty": 15,
        "image": AssetPaths.orderSummaryIcon1,
      },
      {
        "name": "Chicken Steak & Chips",
        "qty": 5,
        "image": AssetPaths.orderSummaryIcon1,
      },
      {
        "name": "Billy's Special",
        "qty": 12,
        "image": AssetPaths.orderSummaryIcon1,
      },
      {
        "name": "The Spicy Dip",
        "qty": 10,
        "image": AssetPaths.orderSummaryIcon1,
      },
      {
        "name": "Charlie's Special",
        "qty": 2,
        "image": AssetPaths.orderSummaryIcon1,
      },
      {
        "name": "Chicken Steak & Rice",
        "qty": 12,
        "image": AssetPaths.orderSummaryIcon1,
      },
    ];

    final totalQty = orderItems.fold<int>(
      0,
      (sum, item) => sum + (item['qty'] as int),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Order Summary",
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch Row - Fixed the Row structure
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1E4C9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.r),
                          bottomLeft: Radius.circular(8.r),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "1. Branch Name",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.authBodyTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Second color section - Total Units
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: const Color(0xFFE6ECDE),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Total Units: 76", // Fixed: added actual units value
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.authBodyTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Third color section - Approved Button
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF5BB450),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Center(
                        child: Text(
                          "Approved",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // List of items with Total Items
            Expanded(
              child: ListView.separated(
                itemCount: orderItems.length + 1,
                separatorBuilder: (context, index) {
                  if (index == orderItems.length - 1) {
                    return SizedBox(height: 10.h);
                  }
                  return Divider(
                    color: const Color(0xFFEFEFEF),
                    thickness: 1,
                    height: 16.h,
                  );
                },
                itemBuilder: (context, index) {
                  // Total Items row
                  if (index == orderItems.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 16.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Items:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            "$totalQty pcs",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Regular item rows
                  final item = orderItems[index];
                  return Row(
                    children: [
                      Text(
                        "${index + 1}.",
                        style: TextStyle(
                          color: AppColors.authBodyTextColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: Image.asset(
                          item["image"],
                          height: 40.h,
                          width: 40.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          item["name"],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        "${item["qty"].toString().padLeft(2, '0')} pcs",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Success Message and Make Invoice Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You approved Branch Name\'s order. Now you can make invoice.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.authBodyTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AuthButton(
                    text: 'Make Invoice',
                    onPressed: () {
                      // Handle make invoice action
                      Navigator.pushNamed(
                        context,
                        RouteNames.headOfficeInvoiceScreen,
                      );
                    },
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
