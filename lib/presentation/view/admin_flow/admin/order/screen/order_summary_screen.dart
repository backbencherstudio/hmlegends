import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/order/order_screen_provider.dart';
import '../../widget/search_filter.dart';
import '../widget/order_summary_card.dart';

class OrderSummaryScreen extends StatefulWidget {
  final bool fromBottomNav;

  const OrderSummaryScreen({super.key, required this.fromBottomNav});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  String selectedPeriod = 'Today';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderScreenProvider>(context);
    final total_order = provider.orderAdminModel?.data?.stats?.total ?? 0;
    final pending_order = provider.orderAdminModel?.data?.stats?.pending ?? 0;
    final invoiced_order = provider.orderAdminModel?.data?.stats?.invoiced ?? 0;
    final delivered_order =
        provider.orderAdminModel?.data?.stats?.delivered ?? 0;
    final total_unit_ordered =
        provider.orderAdminModel?.data?.stats?.totalUnitOrdered ?? 0;
    final orders = provider.orderAdminModel?.data?.orders ?? [];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Order Summary",
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        useBottomNavBack: widget.fromBottomNav,
      ),

      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchField(hintText: ''),
            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  child: OrderSummaryCard(
                    title: "Total Orders",
                    value: "$total_order",
                    isHighlighted: true,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Pending Orders",
                    value: "$pending_order",
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Invoiced Orders",
                    value: "$invoiced_order",
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: OrderSummaryCard(
                    title: "Delivered Orders",
                    value: "$delivered_order",
                    isWide: true,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Units of items ordered",
                    value: "$total_unit_ordered",
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

                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      selectedPeriod = value;
                    });
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'Today', child: Text('Today')),
                    PopupMenuItem(value: 'This week', child: Text('This week')),
                    PopupMenuItem(
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
            SizedBox(height: 14.h),

            Expanded(
              child: provider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: orders.length,
                      padding: EdgeInsets.only(bottom: 8.h),
                      itemBuilder: (context, index) {
                        final item = orders[index];

                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Container(
                            height: 40.h,
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
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${index + 1}.  ${item.user?.name ?? ""}",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.authBodyTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    color: const Color(0xFFE6ECDE),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Total Units: ${item.totalQuantity ?? 'Unknown'}",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: AppColors.authBodyTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

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
                                        Navigator.pushNamed(
                                          context,
                                          RouteNames.orderSummaryViewScreen,
                                        );
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
