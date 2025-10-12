import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/widget/simple_appbar.dart';
import '../../../../../core/constant/asset_path.dart';
import 'package:intl/intl.dart';

class MyOrders extends StatefulWidget {
  final TextEditingController? controller;

  const MyOrders({super.key, this.controller});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String selectedPeriod = 'Today';
  String? expandedDate;

  final Map<String, List<String>> foodList = {
    'Today': List.generate(5, (index) => 'Today Food ${index + 1}'),
    'This Week': List.generate(5, (index) => 'Weekly Food ${index + 1}'),
    'This Month': List.generate(5, (index) => 'Monthly Food ${index + 1}'),
  };

  @override
  void initState() {
    super.initState();
    expandedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  List<String> getDateList() {
    final now = DateTime.now();
    if (selectedPeriod == 'Today') {
      return [DateFormat('dd/MM/yyyy').format(now)];
    } else if (selectedPeriod == 'This Week') {
      return List.generate(
          7, (i) => DateFormat('dd/MM/yyyy').format(now.subtract(Duration(days: 6 - i))));
    } else if (selectedPeriod == 'This Month') {
      int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      return List.generate(
          daysInMonth, (i) => DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, i + 1)));
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final dates = getDateList();

    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: SimpleAppbar(
        title: 'My Orders',
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
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
                            expandedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
              child: ListView.separated(
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
                            children: List.generate(foodList[selectedPeriod]!.length, (foodIndex) {
                              final food = 'PERI CHICKEN WRAP';
                              return ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${foodIndex + 1}.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff4A4C56),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.asset(
                                        'assets/images/food_burger.png',
                                        width: 45.w,
                                        height: 25.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  food,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff4A4C56),
                                  ),
                                ),
                                trailing: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '1 ',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xff4A4C56),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Pcs',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff777980),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
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
