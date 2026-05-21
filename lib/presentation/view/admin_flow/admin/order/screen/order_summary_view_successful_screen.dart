import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import 'package:provider/provider.dart';
import '../../../../widget/custom_app_bar_2.dart';

class OrderSummaryViewSuccessfulScreen extends StatefulWidget {
  const OrderSummaryViewSuccessfulScreen({super.key});

  @override
  State<OrderSummaryViewSuccessfulScreen> createState() =>
      _OrderSummaryViewSuccessfulScreenState();
}

class _OrderSummaryViewSuccessfulScreenState
    extends State<OrderSummaryViewSuccessfulScreen> {
  String selectedPeriod = 'Today';
  String? branchId;
  Map<String, bool> expandedGroups = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      branchId = ModalRoute.of(context)?.settings.arguments as String?;
      if (branchId != null) {
        // ignore: use_build_context_synchronously
        context.read<ManageBranchProvider>().getSingleBranch(branchId!);
      }
    });
  }

  String _getPeriodValue(String period) {
    switch (period) {
      case 'Today':
        return 'today';
      case 'This week':
        return 'week';
      case 'This month':
        return 'month';
      default:
        return 'today';
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --------------- Branch Name ------------------------------------
              Consumer<ManageBranchProvider>(
                builder: (
                  BuildContext context,
                  ManageBranchProvider provider,
                  Widget? child,
                ) {
                  final singleBranchData = provider.singleBranchModel;
                  if (singleBranchData?.data == null) {
                    return Container();
                  }
                  final branchName = singleBranchData!.data!.name;
                  final branchAddress = singleBranchData.data!.address;
                  final branchStatus = singleBranchData.data!.status;

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AssetPaths.orderSummaryIcon1,
                          fit: BoxFit.contain,
                          width: 80.w,
                          height: 80.h,
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$branchName",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'Roboto',
                                color: Color(0xFF1D1F2C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.primaryColor,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "$branchAddress",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Roboto',
                                    color: Color(0xFF4A4C56),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF5BB450).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(99.r),
                          ),
                          child: Text(
                            "$branchStatus",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Roboto',
                              color: Color(0xFF5BB450),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              /// ---------------  List of items with Total Items ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Items",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Roboto',
                      color: Color(0xFF1D1F2C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        selectedPeriod = value;
                      });

                      ///----------- Call API with new period -----------------
                      if (branchId != null) {
                        context.read<ManageBranchProvider>().getSingleBranch(
                          branchId!,
                          period: _getPeriodValue(value),
                        );
                      }
                    },
                    itemBuilder:
                        (context) => const [
                          PopupMenuItem(value: 'Today', child: Text('Today')),
                          PopupMenuItem(
                            value: 'This week',
                            child: Text('This week'),
                          ),
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
              SizedBox(height: 24.h),
              Consumer<ManageBranchProvider>(
                builder: (
                  BuildContext context,
                  ManageBranchProvider provider,
                  Widget? child,
                ) {
                  final singleBranchData = provider.singleBranchModel;
                  if (singleBranchData?.data == null) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: Text(
                          "No order data available",
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  final orderItems =
                      singleBranchData!.data!.orders!
                          .expand(
                            (order) => (order.orderItems ?? []).map(
                              (item) => {
                                "qty": item.quantity,
                                "image": item.productImage,
                                "date": order.createdAt,
                              },
                            ),
                          )
                          .toList();

                  if (orderItems.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: Text(
                          "No order items found",
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  // Group items by time (Today) or by date (This week/month)
                  Map<String, List<Map<String, dynamic>>> groupedItems = {};

                  for (var item in orderItems) {
                    String groupKey;
                    if (selectedPeriod == 'Today') {
                      // Group by time (e.g., "09:00 AM")
                      final dateTime = DateTime.tryParse(
                        (item['date'] as String?) ?? '',
                      );
                      groupKey =
                          dateTime != null
                              ? "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}"
                              : 'Unknown Time';
                    } else {
                      // Group by date (e.g., "Mon, Jan 15")
                      final dateTime = DateTime.tryParse(
                        (item['date'] as String?) ?? '',
                      );
                      if (dateTime != null) {
                        final days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        final months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec',
                        ];
                        groupKey =
                            "${days[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day}";
                      } else {
                        groupKey = 'Unknown Date';
                      }
                    }

                    if (!groupedItems.containsKey(groupKey)) {
                      groupedItems[groupKey] = [];
                    }
                    groupedItems[groupKey]?.add(item);
                  }

                  final sortedGroups =
                      groupedItems.entries.toList()
                        ..sort((a, b) => a.key.compareTo(b.key));

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedGroups.length,
                    itemBuilder: (context, groupIndex) {
                      final group = sortedGroups[groupIndex];
                      final groupKey = group.key;
                      final items = group.value;
                      items.fold<int>(
                        0,
                        (sum, item) => sum + (item['qty'] as int? ?? 0),
                      );

                      bool isExpanded = expandedGroups[groupKey] ?? true;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Time/Date Header
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  expandedGroups[groupKey] =
                                      !(expandedGroups[groupKey] ?? true);
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      groupKey,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    Transform.rotate(
                                      angle: isExpanded ? 0 : 3.14159,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.primaryColor,
                                        size: 24.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded) ...[
                              SizedBox(height: 12.h),
                              // Items under this time/date
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: const Color(0xFFEFEFEF),
                                    thickness: 1,
                                    height: 16.h,
                                  );
                                },
                                itemBuilder: (context, itemIndex) {
                                  final item = items[itemIndex];
                                  return Row(
                                    children: [
                                      Text(
                                        "${itemIndex + 1}.",
                                        style: TextStyle(
                                          color: AppColors.authBodyTextColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                        child:
                                            item["image"] != null
                                                ? Image.network(
                                                  item["image"],
                                                  height: 40.h,
                                                  width: 40.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Container(
                                                      height: 40.h,
                                                      width: 40.h,
                                                      color: Colors.grey[300],
                                                      child: Icon(
                                                        Icons.broken_image,
                                                      ),
                                                    );
                                                  },
                                                )
                                                : Container(
                                                  height: 40.h,
                                                  width: 40.h,
                                                  color: Colors.grey[300],
                                                ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          item["name"] ?? "N/A",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${(item["qty"] ?? 0).toString().padLeft(2, '0')} pcs",
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
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
