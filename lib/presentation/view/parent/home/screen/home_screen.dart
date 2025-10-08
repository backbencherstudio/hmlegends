import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';

import '../widget/weekly_bar_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: '', profileImage: AssetPaths.personIcon, notificationCount: 4,),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h,),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.headOfficeRadiusColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '20 Sep, 2025',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: _buildCustomChip(),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),
                  Text(
                    'Stock Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Stock level',
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: 0.15,
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                      minHeight: 10.h,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '15%',
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Grid Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.9,
              children: [
                _infoCard(
                  'Invoices',
                  'Status',
                  '','',
                  'Paid Invoices',
                  '4/6',

                  Icons.receipt_long_outlined,
                  Colors.blue,
                ),
                _infoCard(
                  'Manage',
                  'Branches',
                  '','',
                  'Active: 8',
                  'Locked 0',

                  Icons.location_on_outlined,
                  Colors.green,
                ),
                _infoCard(
                  'Orders',
                  'Summary',
                  '','',
                  'Total Orders',
                  '6/8',

                  Icons.local_shipping_outlined,
                  Colors.orange,
                ),
                _infoCard(
                  'Manage',
                  'Delivery',
                  "Today's Delivery",
                  '00',
                  "Today's Delivery",
                  '00',
                  Icons.delivery_dining,
                  Colors.purple,
                ),
              ],
            ),

            SizedBox(height: 5.h),
            Text(
              'Items Ordered (Last 7 Days)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
            ),
            SizedBox(height: 12.h),
            WeeklyBarChart(),
          ],
        ),
      ),
    );
  }

  // Custom Chip replacement
  Widget _buildCustomChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            color: Colors.red,
            size: 17.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            'Stock Low',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.headOfficeRadiusColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
      String title,
      String title1,
      String line1,
      String line2,
      String? line3,
      String? line4,
      IconData icon,
      Color color,
      ) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with icon and titles
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      title1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Spacer to push bottom section down
          Expanded(child: Container()),

          // Bottom section with two texts
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bottom left text
                Text(
                  line1,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Bottom right text
                Text(
                  line2,
                  style: TextStyle(
                    color: color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bottom left text
                Text(
                  line3??'',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Bottom right text
                Text(
                  line4??'',
                  style: TextStyle(
                    color: color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}