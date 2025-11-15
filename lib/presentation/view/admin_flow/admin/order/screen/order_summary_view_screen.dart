import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/order/widget/approve_show_dialog.dart';
import '../../../../widget/custom_app_bar_2.dart';

class OrderSummaryViewScreen extends StatelessWidget {
  const OrderSummaryViewScreen({super.key});

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

    final totalQty =
    orderItems.fold<int>(0, (sum, item) => sum + (item['qty'] as int));

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
            // Branch Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Branch Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      showApproveDialog(context,  'Are you sure you want to approve today’s order?');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                      padding:EdgeInsets.symmetric(horizontal: 16.h,vertical: 16.w),
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
          ],
        ),
      ),
    );
  }
}


