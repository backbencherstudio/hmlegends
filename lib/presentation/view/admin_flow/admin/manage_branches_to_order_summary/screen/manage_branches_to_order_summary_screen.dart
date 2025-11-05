import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import '../../../../widget/custom_app_bar_2.dart';

class ManageBranchesToOrderSummaryScreen extends StatefulWidget {
  const ManageBranchesToOrderSummaryScreen({super.key});

  @override
  State<ManageBranchesToOrderSummaryScreen> createState() => _ManageBranchesToOrderSummaryScreenState();
}

class _ManageBranchesToOrderSummaryScreenState extends State<ManageBranchesToOrderSummaryScreen> {

  String selectedPeriod = 'Today';

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

    // Branch data
    final Map<String, dynamic> branch = {
      "name": "Branch Name/ID",
      "address": "2118 Thornridge Cir. Syracuse, Connecticut 35624",
      "status": "Active",
      "image": AssetPaths.personIcon1,
    };

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
              child: _buildBranchCard(branch, context),
            ),

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
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      selectedPeriod = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Today', child: Text('Today')),
                    const PopupMenuItem(
                      value: 'This week',
                      child: Text('This week'),
                    ),

                    const PopupMenuItem(
                      value: 'This month',
                      child: Text('This month'),
                    ),
                  ],
                  color: const Color(0xFFFFF5F5),
                  child: Row(
                    children: [
                      Text(selectedPeriod, style: TextStyle(fontSize: 14.sp)),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp),
                    ],
                  ),
                ),
              ],
            ),
        Divider(
          color: const Color(0xFFEFEFEF),
          thickness: 1,
          height: 16.h,
        ),
            SizedBox(height: 14.h),
            // List of items
            Expanded(
              child: ListView.separated(
                itemCount: orderItems.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: const Color(0xFFEFEFEF),
                    thickness: 1,
                    height: 16.h,
                  );
                },
                itemBuilder: (context, index) {
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
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch, BuildContext context) {
    final isActive = branch["status"] == "Active";

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Top Row (Image + Info + Status)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  branch["image"],
                  height: 65.h,
                  width: 65.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColors.authHeaderTextColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Image.asset(
                          AssetPaths.locationIcon,
                          height: 22.h,
                          width: 22.w,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            branch["address"],
                            style: TextStyle(
                              color: AppColors.authBodyTextColor,
                              fontSize: 12.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F5E6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  branch["status"],
                  style: TextStyle(
                    color: Color(0xFF5BB450),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}