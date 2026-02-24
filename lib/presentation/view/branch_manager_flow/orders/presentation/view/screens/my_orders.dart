import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/widget/simple_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/constant/asset_path.dart';
import '../../../../../../../core/route/route_names.dart';
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
      Provider.of<GetOrdersViewModel>(context, listen: false).fetchOrders();
    });
  }

  List<String> getDateList(Map<String, List<Data>> groupedOrders) {
    final now = DateTime.now();

    if (selectedPeriod == 'Today') {
      return groupedOrders.keys
          .where((date) => date == DateFormat('dd/MM/yyyy').format(now))
          .toList();
    } else if (selectedPeriod == 'This Week') {
      return groupedOrders.keys.where((date) {
        final d = DateFormat('dd/MM/yyyy').parse(date);
        return d.isAfter(now.subtract(const Duration(days: 6)));
      }).toList();
    } else if (selectedPeriod == 'This Month') {
      return groupedOrders.keys.where((date) {
        final d = DateFormat('dd/MM/yyyy').parse(date);
        return d.month == now.month && d.year == now.year;
      }).toList();
    }

    return groupedOrders.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: SimpleAppbar(
        title: 'My Orders',
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        navigationType: NavigationType.pushReplacementNamed,
        navigationPath: RouteNames.branchParentScreen,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            /// 🔍 Search Bar
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: const Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 22.w,
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey.shade600,
                    size: 22.w,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            /// 🔽 Filter Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items',
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
                      },
                      itemBuilder:
                          (context) => const [
                            PopupMenuItem(value: 'Today', child: Text('Today')),
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

            /// 📦 Orders List
            Expanded(
              child: Consumer<GetOrdersViewModel>(
                builder: (context, vm, child) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.error != null) {
                    return Center(child: Text(vm.error!));
                  }

                  final grouped = vm.groupedByDate();
                  final dates = getDateList(grouped);

                  if (dates.isEmpty) {
                    return const Center(child: Text("No items found"));
                  }

                  return ListView.separated(
                    itemCount: dates.length,
                    separatorBuilder: (_, __) => Divider(thickness: 0.8.h),
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      final isExpanded = expandedDate == date;
                      final ordersOfDate = grouped[date]!;

                      return Column(
                        children: [
                          /// --------------------- Date Header ----------------
                          ListTile(
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
                            Column(
                              children:
                                  ordersOfDate.map((order) {
                                    return Column(
                                      children:
                                          order.orderItems!.map((item) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  leading: Container(
                                                    width: 50.w,
                                                    height: 50.h,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.r,
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
                                                  title: Text(
                                                    item.product ?? '',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    "${item.quantity ?? 0} Pcs",
                                                  ),
                                                ),
                                                Divider(thickness: 0.6.h),
                                              ],
                                            );
                                          }).toList(),
                                    );
                                  }).toList(),
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
    );
  }
}
