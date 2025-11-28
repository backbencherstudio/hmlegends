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
    // Fetch orders via Provider
    Future.microtask(() =>
        Provider.of<GetOrdersViewModel>(context, listen: false).fetchOrders());
  }

  List<String> getDateList(Map<String, List<OrderData>> groupedOrders) {
    final now = DateTime.now();
    if (selectedPeriod == 'Today') {
      return groupedOrders.keys
          .where((date) => date == DateFormat('dd/MM/yyyy').format(now))
          .toList();
    } else if (selectedPeriod == 'This Week') {
      return groupedOrders.keys
          .where((date) {
        final d = DateFormat('dd/MM/yyyy').parse(date);
        return d.isAfter(now.subtract(const Duration(days: 6)));
      })
          .toList();
    } else if (selectedPeriod == 'This Month') {
      return groupedOrders.keys
          .where((date) {
        final d = DateFormat('dd/MM/yyyy').parse(date);
        return d.month == now.month && d.year == now.year;
      })
          .toList();
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: const Color(0xff1D1F2C),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      selectedPeriod,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: const Color(0xff4A4C56),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      onSelected: (value) {
                        setState(() {
                          selectedPeriod = value;
                          if (value == 'Today') {
                            expandedDate =
                                DateFormat('dd/MM/yyyy').format(DateTime.now());
                          } else {
                            expandedDate = null;
                          }
                        });
                      },
                      itemBuilder: (context) => const [
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
                    separatorBuilder: (context, index) => Divider(
                      thickness: 0.8.h,
                      color: const Color(0xffE0E0E0),
                      indent: 10.w,
                      endIndent: 10.w,
                    ),
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      final isExpanded = expandedDate == date;
                      final ordersOfDate = grouped[date]!;

                      return Column(
                        children: [
                          ListTile(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            leading: Text(
                              '${index + 1}.',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff4A4C56),
                                fontSize: 16.sp,
                              ),
                            ),
                            title: Text(
                              date,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff4A4C56),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up_sharp
                                    : Icons.keyboard_arrow_down_sharp,
                                color: Colors.grey.shade600,
                                size: 22.w,
                              ),
                              onPressed: () {
                                setState(() {
                                  expandedDate = isExpanded ? null : date;
                                });
                              },
                            ),
                          ),

                          if (isExpanded)
                            Padding(
                              padding: EdgeInsets.only(left: 2.w, bottom: 8.h),
                              child: Column(
                                children: ordersOfDate.map((order) {
                                  return ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...order.items.map((item) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: 50.w,
                                                  height: 50.h,

                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30.r),
                                          ),
                                                    child: Image.asset('assets/images/food_burger.png')

                                                ),
                                                Text(
                                                  item.product.name,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  "${item.quantity} × ${item.product.price}",
                                                  style:
                                                  const TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        const Divider(),
                                        Text("Total Quantity: ${order.totalQuantity}"),
                                        Text("Total Amount: ${order.totalAmount}"),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
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
