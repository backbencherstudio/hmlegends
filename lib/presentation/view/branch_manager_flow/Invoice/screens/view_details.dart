import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import '../../../widget/simple_appbar.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({super.key});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xffFFF6F7),
          appBar: SimpleAppbar(
            profileImage: AssetPaths.personIcon,
            notificationCount: 4,
            title: 'Invoice',
            navigationType: NavigationType.pop,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15.0.w),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0.w, vertical: 30.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Invoice From Row + Paid Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: _AddressSection(
                                    title: 'Invoice From',
                                    name: 'JHON DOE',
                                    address:
                                    '1550 Silky Blue Road San Francisco California',
                                    phone: '(123) 123456-789',
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder:
                                      (Widget child, Animation<double> anim) {
                                    return FadeTransition(
                                      opacity: anim,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.3, 0),
                                          end: Offset.zero,
                                        ).animate(anim),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: isPaid
                                      ? Container(
                                    key: const ValueKey('paid'),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    decoration: BoxDecoration(
                                      color:  Color(0xFF5BB450),
                                      borderRadius:
                                      BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      children: [
                                       Container(
                                         width: 25.w,
                                         height: 25.h,
                                         decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                         ),
                                         child: Icon(Icons.check,
                                             color: Colors.red,
                                             size: 22.w),
                                       ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          'Paid',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),

                            Divider(
                                height: 35.h,
                                thickness: 1,
                                color: const Color(0xFFE0E0E0)),

                            const _AddressSection(
                              title: 'Ship to',
                              name: 'JHON DOE',
                              address:
                              '1550 Silky Blue Road San Francisco California',
                              phone: '(123) 123456-789',
                            ),
                            Divider(
                                height: 35.h,
                                thickness: 1,
                                color: const Color(0xFFE0E0E0)),

                            const _DateInvoiceRow(
                              date: '20 APRIL 2025',
                              invoiceNo: 'FS618A',
                            ),
                            _InvoiceTable(items: mockItems),
                            SizedBox(height: 20.h),
                            const _SubtotalRow(subtotal: '£588'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔹 Conditional Bottom Bar
                if (!isPaid)
                  _BottomActionBar(
                    onPaid: () {
                      setState(() {
                        isPaid = true;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ------------------------------------------------------------
/// WIDGETS BELOW
/// ------------------------------------------------------------

class _AddressSection extends StatelessWidget {
  final String title;
  final String name;
  final String address;
  final String phone;

  const _AddressSection({
    required this.title,
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFF9E9E9E),
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.h),
        Text(
          address,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF616161),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          phone,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF616161),
          ),
        ),
      ],
    );
  }
}

class _DateInvoiceRow extends StatelessWidget {
  final String date;
  final String invoiceNo;

  const _DateInvoiceRow({required this.date, required this.invoiceNo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Date: $date',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          'Invoice No: $invoiceNo',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// Table showing invoice items
class _InvoiceTable extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _InvoiceTable({required this.items});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: const Color(0xFFE0E0E0)),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text('Item',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text('Qty',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text('Amount',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ),
          ],
        ),
        for (var item in items)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Text(item['name']),
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Text(item['qty'].toString()),
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Text('£${item['price']}'),
              ),
            ],
          ),
      ],
    );
  }
}

class _SubtotalRow extends StatelessWidget {
  final String subtotal;

  const _SubtotalRow({required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Subtotal: $subtotal',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Bottom Action Buttons
class _BottomActionBar extends StatelessWidget {
  final VoidCallback onPaid;

  const _BottomActionBar({required this.onPaid});

  void _onExport() {
    debugPrint('Exporting invoice...');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 50.0.h),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120.w),
          ElevatedButton(
            onPressed: onPaid,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE20613),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 35.w),
              elevation: 5,
            ),
            child: Text(
              'Pay bill',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          TextButton.icon(
            onPressed: _onExport,
            icon: Image.asset('assets/icons/export.png', scale: 3.5),
            label: Text(
              'Export',
              style: TextStyle(
                fontSize: 16.sp,
                color:  Color(0xFF5BB450),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock Data
final List<Map<String, dynamic>> mockItems = [
  {'name': 'Web Design', 'qty': 1, 'price': 250},
  {'name': 'App UI Design', 'qty': 1, 'price': 200},
  {'name': 'Hosting', 'qty': 1, 'price': 138},
];
