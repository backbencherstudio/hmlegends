import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin_model/order/order_admin_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/order/order_screen_provider.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../../widget/search_filter.dart';
import '../widget/order_summary_card.dart';

class OrderSummaryScreen extends StatefulWidget {
  final bool fromBottomNav;

  const OrderSummaryScreen({super.key, required this.fromBottomNav});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  String? loadingOrderId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderScreenProvider>().getAdminOrder();
      context.read<AdminNotificationProvider>().getAdminNotification();
    });
    super.initState();
  }

  List<Orders> _getFilteredStats(OrderScreenProvider provider) {
    final allOrders = provider.orderAdminModel?.data?.orders ?? [];
    switch (provider.selectedFilterOrder) {
      case 0: // All orders
        return allOrders;
      case 1: // Pending orders
        return allOrders
            .where((order) => order.status?.trim().toUpperCase() == "PENDING")
            .toList();
      case 2: // Invoiced orders
        return allOrders
            .where((order) {
              final status = order.status?.trim().toUpperCase();
              return status == "APPROVED" ||
                  status == "INVOICED" ||
                  status == "PROCESSING" ||
                  status == "INVOICE" ||
                  status == "INVOICE_GENERATED" ||
                  status == "PAID";
            })
            .toList();
      case 3: // Delivered orders
        return allOrders
            .where((order) {
              final status = order.status?.trim().toUpperCase();
              return status == "DELIVERED" ||
                  status == "COMPLETED" ||
                  status == "RECEIVED" ||
                  status == "DELIVERY_COMPLETED";
            })
            .toList();
      case 4: // Units of items ordered
        return allOrders;
      default:
        return allOrders;
    }
  }

  String _getFilterTitle(int filter) {
    switch (filter) {
      case 1:
        return "Pending Orders";
      case 2:
        return "Invoiced Orders";
      case 3:
        return "Delivered Orders";
      case 4:
        return "Units Ordered";
      default:
        return "Total Orders";
    }
  }

  List<Orders> _applyQueryFilter(List<Orders> orders) {
    if (query.trim().isEmpty) return orders;
    final q = query.trim().toLowerCase();
    return orders.where((order) {
      final name = order.user?.name ?? '';
      return name.toLowerCase().contains(q);
    }).toList();
  }

  List<Data> user = [];
  String query = '';
  Timer? debouncer;

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    /// ------------- Dependency Injection OrderScreenProvider -----------------
    final provider = Provider.of<OrderScreenProvider>(context);
    final allOrders = provider.orderAdminModel?.data?.orders ?? [];

    final pendingCount = allOrders
        .where((order) => order.status?.trim().toUpperCase() == "PENDING")
        .length;
    final invoicedCount = allOrders
        .where((order) {
          final status = order.status?.trim().toUpperCase();
          return status == "APPROVED" ||
              status == "INVOICED" ||
              status == "PROCESSING" ||
              status == "INVOICE" ||
              status == "INVOICE_GENERATED" ||
              status == "PAID";
        })
        .length;
    final deliveredCount = allOrders
        .where((order) {
          final status = order.status?.trim().toUpperCase();
          return status == "DELIVERED" ||
              status == "COMPLETED" ||
              status == "RECEIVED" ||
              status == "DELIVERY_COMPLETED";
        })
        .length;

    final stats = provider.orderAdminModel?.data?.stats;
    final totalOrder = stats?.total ?? allOrders.length;
    final pendingOrder = (stats?.pending != null && stats!.pending! > 0)
        ? stats.pending!
        : pendingCount;
    final invoicedOrder = (stats?.invoiced != null && stats!.invoiced! > 0)
        ? stats.invoiced!
        : invoicedCount;
    final deliveredOrder = (stats?.delivered != null && stats!.delivered! > 0)
        ? stats.delivered!
        : deliveredCount;
    final totalUnitOrdered = stats?.totalUnitOrdered ??
        allOrders.fold<int>(0, (sum, o) => sum + (o.totalQuantity ?? 0));

    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: 'Order Summary',
        profileImage: data?.avatar,
        notificationCount: notificationProvider.unreadCount,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        useBottomNavBack: true,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///------------------ Search Field ----------------------------------
            SearchField(
              hintText: 'Search by branch name',
              text: query,
              onChanged: (String value) {
                if (value.isEmpty) {
                  if (debouncer != null) {
                    debouncer!.cancel();
                  }
                  setState(() {
                    query = '';
                  });
                } else {
                  debounce(() {
                    if (!mounted) return;
                    setState(() {
                      query = value;
                    });
                  }, duration: const Duration(milliseconds: 300));
                }
              },
            ),
            SizedBox(height: 20.h),

            ///------------------ Order Summary Cards --------------------------
            Row(
              children: [
                Expanded(
                  child: OrderSummaryCard(
                    title: "Total Orders",
                    value: "$totalOrder",
                    isHighlighted: provider.selectedFilterOrder == 0,
                    onTap: () {
                      provider.setSelectedFilterOrder(0);
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Pending Orders",
                    value: "$pendingOrder",
                    isHighlighted: provider.selectedFilterOrder == 1,
                    onTap: () {
                      provider.setSelectedFilterOrder(
                        provider.selectedFilterOrder == 1 ? 0 : 1,
                      );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Invoiced Orders",
                    value: "$invoicedOrder",
                    isHighlighted: provider.selectedFilterOrder == 2,
                    onTap: () {
                      provider.setSelectedFilterOrder(
                        provider.selectedFilterOrder == 2 ? 0 : 2,
                      );
                    },
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
                    value: "$deliveredOrder",
                    isWidth: true,
                    isHighlighted: provider.selectedFilterOrder == 3,
                    onTap: () {
                      provider.setSelectedFilterOrder(
                        provider.selectedFilterOrder == 3 ? 0 : 3,
                      );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OrderSummaryCard(
                    title: "Units of items ordered",
                    value: "$totalUnitOrdered",
                    isWidth: true,
                    isHighlighted: provider.selectedFilterOrder == 4,
                    onTap: () {
                      provider.setSelectedFilterOrder(
                        provider.selectedFilterOrder == 4 ? 0 : 4,
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 28.h),

            /// ------------------ Total Orders List ---------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getFilterTitle(provider.selectedFilterOrder),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    provider.setSelectedPeriod(value);
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'today',
                          child: Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.authBodyTextColor,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'week',
                          child: Text(
                            'This week',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.authBodyTextColor,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'month',
                          child: Text(
                            'This month',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.authBodyTextColor,
                            ),
                          ),
                        ),
                      ],
                  color: const Color(0xFFFFF5F5),
                  child: Row(
                    children: [
                      Text(
                        provider.selectedPeriodLabel,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            /// ------------------ Orders List from server ---------------------
            Expanded(
              child:
                  provider.isLoading
                      ? Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(),
                        ),
                      )
                      : provider.orderAdminModel?.data?.orders?.isEmpty ?? true
                      ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 48.sp,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "No Orders Found",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount:
                            _applyQueryFilter(
                              _getFilteredStats(provider),
                            ).length,
                        padding: EdgeInsets.only(bottom: 12.h),
                        itemBuilder: (context, index) {
                          final filteredOrders = _applyQueryFilter(
                            _getFilteredStats(provider),
                          );
                          final item = filteredOrders[index];

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
                                          "${index + 1}.  ${item.user?.name ?? "Unknown User"}",
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
                                        onPressed: loadingOrderId != null
                                            ? null
                                            : () async {
                                                final navigator = Navigator.of(
                                                  context,
                                                );
                                                setState(() {
                                                  loadingOrderId = item.id;
                                                });
                                                try {
                                                  await provider.adminSingleOrder(
                                                    item.id ?? "",
                                                  );
                                                  if (mounted) {
                                                    final status = provider
                                                        .adminSingleOrderModel
                                                        ?.order
                                                        ?.status
                                                        ?.trim()
                                                        .toUpperCase();
                                                    final route = (status == "APPROVED" ||
                                                            status == "INVOICED" ||
                                                            status == "PROCESSING" ||
                                                            status == "DELIVERED" ||
                                                            status == "COMPLETED")
                                                        ? RouteNames.orderSummaryMakeInvoiceScreen
                                                        : RouteNames.orderSummaryViewScreen;
                                                    navigator.pushNamed(
                                                      route,
                                                      arguments: item.id ?? "",
                                                    );
                                                  }
                                                } finally {
                                                  if (mounted) {
                                                    setState(() {
                                                      loadingOrderId = null;
                                                    });
                                                  }
                                                }
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
                                        child: loadingOrderId == item.id
                                            ? SpinKitSpinningLines(
                                                color: Colors.white,
                                                size: 20.sp,
                                              )
                                            : Text(
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
