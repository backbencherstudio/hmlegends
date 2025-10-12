import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../widget/search_filter.dart';
import '../widget/order_summary_card.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderData = [
      {"branch": "Branch Name", "units": 75},
      {"branch": "Branch Name", "units": 85},
      {"branch": "Branch Name", "units": 65},
      {"branch": "Branch Name", "units": 78},
      {"branch": "Branch Name", "units": 85},
      {"branch": "Branch Name", "units": 92},
      {"branch": "Branch Name", "units": 68},
      {"branch": "Branch Name", "units": 82},
    ];

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
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h), // Remove bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchField(),
            SizedBox(height: 20.h),

            /// Summary boxes
            Row(
              children: [
                Expanded(
                  child: OrderSummaryCard(
                    title: "Total Orders",
                    value: "08",
                    isHighlighted: true,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Pending Orders",
                    value: "04",
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Invoiced Orders",
                    value: "07",
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OrderSummaryCard(
                    title: "Dlivered Orders",
                    value: "08",
                    isWide: true,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Units of items ordered",
                    value: "350",
                    isWide: true,
                  ),
                ),
              ],
            ),

            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Orders",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text("Today", style: TextStyle(fontSize: 14.sp)),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp),
                  ],
                ),
              ],
            ),
            SizedBox(height: 14.h),

            /// Order List - Use Expanded to take remaining space
            Expanded(
              child: ListView.builder(
                itemCount: orderData.length,
                padding: EdgeInsets.only(bottom: 10.h),
                itemBuilder: (context, index) {
                  final item = orderData[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          // First color section - Branch Name
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
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${index + 1}. ${item["branch"]}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
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
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Total Units: ${item["units"]}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.authBodyTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Third color section - View Button
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE20614),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.r),
                                  bottomRight: Radius.circular(8.r),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Handle View click
                                  Navigator.pushNamed(context, RouteNames.orderSummaryViewScreen);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8.r),
                                      bottomRight: Radius.circular(8.r),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "View",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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