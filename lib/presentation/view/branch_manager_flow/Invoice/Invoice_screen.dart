import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:intl/intl.dart';
import '../../../../core/constant/asset_path.dart';
import '../../widget/simple_appbar.dart';

class InvoiceScreen extends StatefulWidget {
  final TextEditingController? controller;

  const InvoiceScreen({super.key, this.controller});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String selectedPeriod = 'Today';
  String? expandedDate;

  final Map<String, List<Map<String, dynamic>>> invoiceRecords = {
    'Today': [
      {
        'index': 1,
        'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'totalItems': 5,
      },
      {
        'index': 2,
        'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'totalItems': 3,
      },
    ],
    'This Week': List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      return {
        'index': i + 1,
        'date': DateFormat('dd/MM/yyyy').format(date),
        'totalItems': (i + 1) * 2,
      };
    }),
    'This Month': List.generate(DateTime.now().day, (i) {
      final date = DateTime(DateTime.now().year, DateTime.now().month, i + 1);
      return {
        'index': i + 1,
        'date': DateFormat('dd/MM/yyyy').format(date),
        'totalItems': (i + 1),
      };
    }),
  };

  @override
  void initState() {
    super.initState();
    expandedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  List<Map<String, dynamic>> getCurrentRecords() {
    return invoiceRecords[selectedPeriod] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final records = getCurrentRecords();

    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: SimpleAppbar(
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        title: 'Invoice',
        navigationType: NavigationType.none,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
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
                    Icons.tune,
                    color: Colors.grey.shade600,
                    size: 22.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPeriod = 'Today';
                      expandedDate =
                          DateFormat('dd/MM/yyyy').format(DateTime.now());
                    });
                  },
                  child: Container(
                    height: 90.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: selectedPeriod == 'Today'
                            ? const Color(0xffE20613)
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '01',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1D1F2C),
                          ),
                        ),
                        const Text(
                          'Today’s\nInvoices',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff4A4C56),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _invoiceBox('Paid\nInvoice', 1),
                _invoiceBox('Pending\nInvoice', 1),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                _invoiceBox('Overdue Invoice', 1),
                _invoiceBox('Total Invoice', 1),
              ],
            ),
            SizedBox(height: 20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Invoices',
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
                            expandedDate = DateFormat(
                              'dd/MM/yyyy',
                            ).format(DateTime.now());
                          } else {
                            expandedDate = null;
                          }
                        });
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'Today', child: Text('Today')),
                        PopupMenuItem(
                            value: 'This Week', child: Text('This Week')),
                        PopupMenuItem(
                            value: 'This Month', child: Text('This Month')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final item = records[index];
                  return orderListItem(
                    index: item['index'],
                    date: item['date'],
                    totalItems: item['totalItems'],
                    onViewPressed: () {
                      Navigator.pushNamed(context, RouteNames.viewDetails);
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

  Widget _invoiceBox(String title, int count) {
    return Container(
      height: 90.h,
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xff1D1F2C),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff4A4C56),
            ),
          ),
        ],
      ),
    );
  }

  Widget orderListItem({
    required int index,
    required String date,
    required int totalItems,
    required VoidCallback onViewPressed,
  }) {
    const double dateSectionFlex = 3;
    const double itemsSectionFlex = 3.5;
    const double viewSectionFlex = 1.5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: dateSectionFlex.toInt(),
              child: Container(
                height: 35,
                color: Colors.lightGreen.shade200,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  '$index. $date',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: itemsSectionFlex.toInt(),
              child: Container(
                height: 35,
                color: Colors.lightGreen.shade50,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Total Items: $totalItems',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: viewSectionFlex.toInt(),
              child: SizedBox(
                height: 35,
                child: Material(
                  color: const Color(0xffE20613),
                  child: InkWell(
                    onTap: onViewPressed,
                    child: const Center(
                      child: Text(
                        'View',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
