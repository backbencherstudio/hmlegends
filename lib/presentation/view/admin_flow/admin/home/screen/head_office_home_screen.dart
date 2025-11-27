import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/home/home_screen_provider.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../widget/info_card.dart';
import '../widget/weekly_bar_chart.dart';

class HeadOfficeHomeScreen extends StatelessWidget {
  const HeadOfficeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreenProvider = Provider.of<HomeScreenProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        // profileImage: AssetPaths.personIcon,
        notificationCount: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            _stockCard(context),

            SizedBox(height: 16.h),
            _gridCards(context, homeScreenProvider),

            SizedBox(height: 16.h),
            Text(
              'Items Ordered (Last 7 Days)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: AppColors.authHeaderTextColor,
              ),
            ),
            SizedBox(height: 12.h),
            const WeeklyBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _stockCard(BuildContext context) => Container(
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
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.calendar, color: Colors.white, size: 16.w),
                SizedBox(width: 8.w),
                Text(
                  '20 Sep, 2025',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
            _stockChip(),
          ],
        ),

        SizedBox(height: 10.h),

        Text(
          'Stock Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),

        SizedBox(height: 10.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Stock level',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            Text(
              '15%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),
        Container(
          height: 12.h,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double progress = 0.15; // 15%
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  Container(
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );

  Widget _stockChip() => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Row(
      children: [
        Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: Colors.red,
          size: 16.sp,
        ),
        SizedBox(width: 5.w),
        Transform.translate(
          offset: Offset(0, 1.h),
          child: Text(
            'Stock Low',
            style: TextStyle(
              color: AppColors.headOfficeRadiusColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _gridCards(BuildContext context, HomeScreenProvider provider) {
    final data = provider.invoiceStatusModel?.data;

    final totalInvoice = data?.invoice?.totalInvoice ?? 0;
    final paidInvoice = data?.invoice?.paidInvoice ?? 0;

    final activeBranch = data?.branch?.activeBranch ?? 0;
    final lockedBranch = data?.branch?.lockedBranch ?? 0;

    final totalOrder = data?.order?.totalOrder ?? 0;
    final completedOrder = data?.order?.totalCompletedOrder ?? 0;

    final toDaysDelivery = data?.delivery?.todaysDelivery ?? 0;
    final assignedDelivery = data?.delivery?.assignedDelivery ?? 0;

    return GridView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return InfoCard(
              onTaps: () =>
                  Navigator.pushNamed(context, RouteNames.invoiceStatusScreen),
              title: 'Invoices',
              subtitle: 'Status',
              label1: 'Paid Invoices',
              value1: "$paidInvoice/$totalInvoice",
              iconPath: AssetPaths.invoiceIcon,
            );

          case 1:
            return InfoCard(
              onTaps: () =>
                  Navigator.pushNamed(context, RouteNames.manageBranchesScreen),
              title: 'Manage',
              subtitle: 'Branches',
              label1: 'Active',
              value1: "$activeBranch",
              label2: 'Locked',
              value2: "$lockedBranch",
              iconPath: AssetPaths.branchIcon,
            );

          case 2:
            return InfoCard(
              onTaps: () =>
                  Navigator.pushNamed(context, RouteNames.orderSummaryScreen),
              title: 'Orders',
              subtitle: 'Summary',
              label1: 'Completed Orders',
              value1: "$completedOrder/$totalOrder",
              iconPath: AssetPaths.orderIcon,
            );

          default:
            return InfoCard(
              onTaps: () =>
                  Navigator.pushNamed(context, RouteNames.manageDeliveryScreen),
              title: 'Manage',
              subtitle: 'Delivery',
              label1: "Today's Delivery",
              value1: "$toDaysDelivery",
              label2: 'Assigned Delivery',
              value2: "$assignedDelivery",
              iconPath: AssetPaths.deliveryIcon,
            );
        }
      },
    );
  }
}
