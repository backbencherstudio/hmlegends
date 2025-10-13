import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../widget/search_filter.dart';
import '../widget/invoice_summary_card.dart';

class InvoiceStatusScreen extends StatefulWidget {
  const InvoiceStatusScreen({super.key});

  @override
  State<InvoiceStatusScreen> createState() => _InvoiceStatusScreenState();
}

class _InvoiceStatusScreenState extends State<InvoiceStatusScreen> {
  String selectedPeriod = 'Today';
  List<String> selectedActions = [];

  @override
  void initState() {
    super.initState();
    selectedActions = List.generate(8, (index) => 'View');
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderData = [
      {"branch": "Branch Name", "units": 75},
      {"branch": "Branch Name", "units": 85},
      {"branch": "Branch Name", "units": 65},
      {"branch": "Branch Name", "units": 78},
      {"branch": "Branch Name", "units": 85},
      {"branch": "Branch Name", "units": 92},
      {"branch": "Branch Name", "units": 68},
      {"branch": "Branch Name", "units": 82},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Invoice status",
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchField(hintText: 'Search by branch name'),
            SizedBox(height: 20.h),

            /// Summary boxes
            Row(
              children: [
                Expanded(
                  child: InvoiceSummaryCard(
                    title: "Total Invoices",
                    value: "08",
                    isHighlighted: true,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: InvoiceSummaryCard(
                    title: "Pending Invoices",
                    value: "04",
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: InvoiceSummaryCard(
                    title: "Overdue Invoiced",
                    value: "07",
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: InvoiceSummaryCard(
                    title: "Out Standing Invoices",
                    value: "08",
                    isWide: true,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: InvoiceSummaryCard(
                    title: "Units of items ordered",
                    value: "350",
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
                // Dropdown for Today/This week/This month
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      selectedPeriod = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Today', child: Text('Today')),
                    const PopupMenuItem(
                      value: 'This week',
                      child: Text('This week'),
                    ),

                    const PopupMenuItem(
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

            /// Order List - Use Expanded to take remaining space
            Expanded(
              child: ListView.builder(
                itemCount: orderData.length,
                padding: EdgeInsets.only(bottom: 8.h),
                itemBuilder: (context, index) {
                  final item = orderData[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Container(
                      height: 34.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          // First color section - Branch Name
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
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${index + 1}. ${item["branch"]}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.authBodyTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Second color section - Total Units
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: const Color(0xFFE6ECDE),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Total Units: ${item["units"]}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.authBodyTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Third color section - Dropdown Menu (View/Export/Re-send)
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
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  setState(() {
                                    selectedActions[index] = value;
                                  });

                                  // Handle the action based on selection
                                  if (value == 'View') {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.orderSummaryViewScreen,
                                    );
                                  } else if (value == 'Export') {
                                    // Handle Export
                                    print('Export item $index');
                                  } else if (value == 'Re-send') {
                                    // Handle Re-send
                                    print('Re-send item $index');
                                  }
                                },
                                color: const Color(0xFFFFF5F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'View',
                                    child: Text(
                                      'View',
                                      style: TextStyle(
                                        color: selectedActions[index] == 'View'
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight:
                                            selectedActions[index] == 'View'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Export',
                                    child: Text(
                                      'Export',
                                      style: TextStyle(
                                        color:
                                            selectedActions[index] == 'Export'
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight:
                                            selectedActions[index] == 'Export'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Re-send',
                                    child: Text(
                                      'Re-send',
                                      style: TextStyle(
                                        color:
                                            selectedActions[index] == 'Re-send'
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight:
                                            selectedActions[index] == 'Re-send'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.h,
                                    horizontal: 4.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          selectedActions[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                    ],
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
