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
  String? expandedDate; // The date whose dropdown is expanded

  // Dummy food lists for demo purposes
  final Map<String, List<String>> foodList = {
    'Today': List.generate(5, (index) => 'Today Food ${index + 1}'),
    'This Week': List.generate(5, (index) => 'Weekly Food ${index + 1}'),
    'This Month': List.generate(5, (index) => 'Monthly Food ${index + 1}'),
  };

  @override
  void initState() {
    super.initState();
    // Initially expand the first item for Today
    expandedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  /// Generate list of dates for week or month
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
        padding: const EdgeInsets.all(16.0),
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
                const Text(
                  'Total Items',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff1D1F2C),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      selectedPeriod,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff4A4C56),
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
            const Divider(height: 20),

            Expanded(
              child: ListView.separated(
                itemCount: dates.length,
                separatorBuilder: (context, index) => const Divider(
                  thickness: 0.8,
                  color: Color(0xffE0E0E0),
                  indent: 10,
                  endIndent: 10,
                ),
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final isExpanded = expandedDate == date;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        leading: Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff4A4C56),
                            fontSize: 16,
                          ),
                        ),
                        title: Text(
                          date,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff4A4C56),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_sharp
                                : Icons.keyboard_arrow_down_sharp,
                            color: Colors.grey.shade600,
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
                          padding: const EdgeInsets.only(left: 2, bottom: 8),
                          child: Column(
                            children: List.generate(foodList[selectedPeriod]!.length, (foodIndex) {
                              final food = 'PERI CHICKEN WRAP';
                              return ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${foodIndex + 1}.',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff4A4C56),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/food_burger.png',
                                        width: 45,
                                        height: 25,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  food,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff4A4C56),
                                  ),
                                ),
                                trailing:  RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '1 ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xff4A4C56),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Pcs',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff777980),
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
