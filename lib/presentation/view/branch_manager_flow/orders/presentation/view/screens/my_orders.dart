import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../admin_flow/admin/widget/search_filter.dart';
import '../../../../../admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import '../../../../../admin_flow/view_model/profile/change_pass_provider.dart';
import '../../../../../admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import '../../../viewmodel/get_my_orders_viewmodel.dart';
import '../../../data/get_my_orders_model.dart';

class MyOrders extends StatefulWidget {
  final TextEditingController? controller;

  const MyOrders({super.key, this.controller});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String selectedPeriod = 'Today';
  String? expandedDate;

  @override
  void initState() {
    super.initState();
    expandedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<GetOrdersViewModel>(
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      ).fetchOrders(period: 'today');
    });
  }

  void _handleBack(BuildContext context) {
    context.read<BottomNavViewModel>().updateIndex(0);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  List<String> getDateList(Map<String, List<Data>> groupedOrders) {
    return groupedOrders.keys.toList();
  }

  List<OrderItems> _getFilteredItems(List<Data> orders, String query) {
    List<OrderItems> items = [];
    final q = query.trim().toLowerCase();
    for (var order in orders) {
      if (order.orderItems != null) {
        for (var item in order.orderItems!) {
          if (q.isEmpty ||
              (item.product != null &&
                  item.product!.toLowerCase().contains(q))) {
            items.add(item);
          }
        }
      }
    }
    return items;
  }

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
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFFF6F7),
        appBar: CustomAppBarTwo(
          title: 'My Orders',
          profileImage: data?.avatar,
          notificationCount: notificationProvider.unreadCount,
          colorMain: Colors.white,
          colorSpace: const Color(0xffFFF6F7),
          onBackTap: () => _handleBack(context),
          onProfileTap: () {
            context.read<BottomNavViewModel>().updateIndex(3);
          },
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              /// ------------------------- Search Bar ---------------------------
              SearchField(
                hintText: 'Search by name',
                text: context.watch<GetOrdersViewModel>().query,
                onChanged: (String value) {
                  if (!mounted) return;
                  context.read<GetOrdersViewModel>().setQuery(value);
                },
              ),

              SizedBox(height: 20.h),

              /// -------------------- Filter Header -----------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedPeriod == 'Today' ? 'Total Items' : 'Total Orders',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        selectedPeriod,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        onSelected: (value) {
                          setState(() {
                            selectedPeriod = value;
                            expandedDate =
                                value == 'Today'
                                    ? DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(DateTime.now())
                                    : null;
                          });
                          final apiPeriod =
                              value == 'Today'
                                  ? 'today'
                                  : value == 'This Week'
                                  ? 'week'
                                  : 'month';
                          Provider.of<GetOrdersViewModel>(
                            context,
                            listen: false,
                          ).fetchOrders(period: apiPeriod);
                        },
                        itemBuilder:
                            (context) => const [
                              PopupMenuItem(
                                value: 'Today',
                                child: Text('Today'),
                              ),
                              PopupMenuItem(
                                value: 'This Week',
                                child: Text('This Week'),
                              ),
                              PopupMenuItem(
                                value: 'This Month',
                                child: Text('This Month'),
                              ),
                            ],
                      ),
                    ],
                  ),
                ],
              ),

              Divider(height: 20.h),

              /// -------------------  Orders List -------------------------------
              Expanded(
                child: Consumer<GetOrdersViewModel>(
                  builder: (context, vm, child) {
                    if (vm.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (vm.error != null) {
                      return Center(child: Text(vm.error!));
                    }

                    if (selectedPeriod == 'Today') {
                      final todayItems = _getFilteredItems(vm.orders, vm.query);

                      if (todayItems.isEmpty) {
                        return const Center(child: Text("No items found"));
                      }

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: todayItems.length,
                        separatorBuilder:
                            (_, __) => Divider(thickness: 0.6.h, height: 12.h),
                        itemBuilder: (context, index) {
                          final item = todayItems[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${index + 1}. ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: const Color(0xff4A4C56),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 40.w,
                                  height: 24.h,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Image.network(
                                    item.productImage ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => const Icon(
                                          Icons.image_not_supported,
                                        ),
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              item.product ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                color: const Color(0xff1D1F2C),
                              ),
                            ),
                            trailing: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: const Color(0xff1D1F2C),
                                ),
                                children: [
                                  TextSpan(
                                    text: "${item.quantity ?? 0} ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "Pcs",
                                    style: TextStyle(color: Color(0xff8E909A)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    final grouped = vm.groupedByDate();
                    final dates = getDateList(grouped);

                    if (dates.isEmpty) {
                      return const Center(child: Text("No items found"));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => Divider(thickness: 0.4.h),
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        final isExpanded = expandedDate == date;
                        final ordersOfDate = grouped[date]!;

                        return Column(
                          children: [
                            /// --------------------- Date Header ----------------
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Text(
                                '${index + 1}.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                              title: Text(
                                date,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_sharp
                                      : Icons.keyboard_arrow_down_sharp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    expandedDate = isExpanded ? null : date;
                                  });
                                },
                              ),
                            ),

                            /// ----------------- Expanded Items -----------------
                            if (isExpanded)
                              Builder(
                                builder: (context) {
                                  final itemsOfDate = _getFilteredItems(
                                    ordersOfDate,
                                    vm.query,
                                  );
                                  return Column(
                                    children: List.generate(itemsOfDate.length, (
                                      itemIndex,
                                    ) {
                                      final item = itemsOfDate[itemIndex];
                                      return Column(
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${itemIndex + 1}. ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.sp,
                                                    color: const Color(
                                                      0xff4A4C56,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Container(
                                                  width: 40.w,
                                                  height: 24.h,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8.r,
                                                        ),
                                                  ),
                                                  child: Image.network(
                                                    item.productImage ?? '',
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          _,
                                                          __,
                                                          ___,
                                                        ) => const Icon(
                                                          Icons
                                                              .image_not_supported,
                                                        ),
                                                    loadingBuilder: (
                                                      context,
                                                      child,
                                                      progress,
                                                    ) {
                                                      if (progress == null) {
                                                        return child;
                                                      }
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            title: Text(
                                              item.product ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.sp,
                                                color: const Color(0xff1D1F2C),
                                              ),
                                            ),
                                            trailing: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: const Color(
                                                    0xff1D1F2C,
                                                  ),
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${item.quantity ?? 0} ",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: "Pcs",
                                                    style: TextStyle(
                                                      color: Color(0xff8E909A),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 0.6.h,
                                            height: 12.h,
                                          ),
                                        ],
                                      );
                                    }),
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
