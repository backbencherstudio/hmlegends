import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';

class DriverBranchDetailScreen extends StatefulWidget {
  const DriverBranchDetailScreen({super.key});

  @override
  State<DriverBranchDetailScreen> createState() => _DriverBranchDetailScreenState();
}

class _DriverBranchDetailScreenState extends State<DriverBranchDetailScreen> {
  bool isDeliveryStarted = false;
  Set<int> checkedIndexes = {};

  final List<Map<String, dynamic>> products = [
    {"name": "Peri Chicken Wrap", "quantity": "20"},
    {"name": "The Khamzat Krunch", "quantity": "18"},
    {"name": "Cheeseburger Meal", "quantity": "25"},
    {"name": "Chicken Nugget Meal", "quantity": "21"},
    {"name": "The Spicy Dip", "quantity": "15"},
    {"name": "Chicken Nugget Meal", "quantity": "17"},
    {"name": "The Honey & Brie Burger", "quantity": "32"},
    {"name": "Billy's Special", "quantity": "28"},
    {"name": "Fish Finger Meal", "quantity": "24"},
    {"name": "Chicken Steak & Chips", "quantity": "16"},
  ];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = args?["name"] ?? "Branch Name-01";
    final address =
        args?["address"] ?? "4140 Parker Rd. Allentown, New Mexico 31134";
    final productsCount = args?["products"] ?? "216";

    final isAllSelected = checkedIndexes.length == products.length;

    return Scaffold(
      appBar: const CustomAppBar(notificationCount: 0, backArrow: "true"),
      body: Column(
        children: [
          // Header Container (White background)
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  address,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Products:   ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      productsCount,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Gradient Background for List and Button
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFDECEE), Color(0xFFF6B7B7)],
                ),
              ),
              child: Column(
                children: [
                  // Select All Row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isAllSelected) {
                            checkedIndexes.clear();
                          } else {
                            checkedIndexes.addAll(List.generate(products.length, (i) => i));
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              color: isAllSelected
                                  ? const Color(0xFFED5E68)
                                  : Colors.transparent,
                              border: Border.all(
                                color: const Color(0xFFED5E68),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: isAllSelected
                                ? Icon(
                                    Icons.check,
                                    size: 16.sp,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            "Select All",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      itemCount: products.length,
                      separatorBuilder:
                          (context, index) => Divider(
                            color: Colors.grey.shade300,
                            height: 24.h,
                            thickness: 1,
                          ),
                      itemBuilder: (context, index) {
                        final prod = products[index];
                        final isChecked = checkedIndexes.contains(index);
                        final isCrossedOut = isDeliveryStarted && isChecked;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isChecked) {
                                checkedIndexes.remove(index);
                              } else {
                                checkedIndexes.add(index);
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 28.w,
                                  child: Text(
                                    "${index + 1}.",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    color: isChecked
                                        ? const Color(0xFFED5E68)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: const Color(0xFFED5E68),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: isChecked
                                      ? Icon(
                                          Icons.check,
                                          size: 16.sp,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    prod["name"],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isCrossedOut
                                          ? Colors.black38
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      decoration: isCrossedOut
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      prod["quantity"],
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Pcs",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Start Delivery Button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    color: Colors.transparent,
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: isAllSelected
                              ? () {
                                  if (!isDeliveryStarted) {
                                    setState(() {
                                      isDeliveryStarted = true;
                                      checkedIndexes.clear();
                                    });
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.driverDeliveryNoteScreen,
                                      arguments: args,
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED5E68),
                            disabledBackgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isDeliveryStarted
                                ? "Proceed to delivery note"
                                : "Start Delivery",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
