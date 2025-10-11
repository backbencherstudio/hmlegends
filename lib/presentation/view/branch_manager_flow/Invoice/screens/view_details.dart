import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/asset_path.dart';
import '../../../widget/simple_appbar.dart';

class InvoiceItem {
  final String no;
  final String name;
  final String price;
  final int quantity;
  final String total;

  const InvoiceItem(this.no, this.name, this.price, this.quantity, this.total);
}

final List<InvoiceItem> mockItems = [
  const InvoiceItem('01', 'Peri Chicken Wrap', '£10', 10, '100'),
  const InvoiceItem('02', "Billy's Special", '£12', 12, '144'),
  const InvoiceItem('03', 'Chicken Steak & Chips', '£8', 15, '120'),
  const InvoiceItem('04', 'The Spicy Dip', '£6.5', 16, '104'),
  const InvoiceItem('05', 'Chicken Steak & Rice', '£7.5', 16, '120'),
];

class ViewDetails extends StatelessWidget {
  const ViewDetails({super.key});

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
                            // 1. Invoice From Section
                            const _AddressSection(
                              title: 'Invoice From',
                              name: 'JHON DOE',
                              address:
                              '1550 Silky Blue Road San Francisco California',
                              phone: '(123) 123456-789',
                            ),
                            Divider(height: 35.h, thickness: 1, color: const Color(0xFFE0E0E0)),

                            // 2. Ship To Section
                            const _AddressSection(
                              title: 'Ship to',
                              name: 'JHON DOE',
                              address:
                              '1550 Silky Blue Road San Francisco California',
                              phone: '(123) 123456-789',
                            ),
                            Divider(height: 35.h, thickness: 1, color: const Color(0xFFE0E0E0)),
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
                const _BottomActionBar(),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1F2C),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff4A4C56),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          address,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4A4C56),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          phone,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF757575),
          ),
        ),
      ],
    );
  }
}

class _DateInvoiceRow extends StatelessWidget {
  final String date;
  final String invoiceNo;

  const _DateInvoiceRow({
    required this.date,
    required this.invoiceNo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DATE: $date',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff4A4C56),
              ),
            ),
            Text(
              'INVOICE NO: $invoiceNo',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff4A4C56),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h,),
        Divider(height: 1.h),
      ],
    );
  }
}

class _InvoiceTable extends StatelessWidget {
  final List<InvoiceItem> items;

  const _InvoiceTable({required this.items});

  Widget _buildHeaderCell(String text,
      {Alignment alignment = Alignment.centerLeft}) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text,
      {Alignment alignment = Alignment.centerLeft,
        FontWeight fontWeight = FontWeight.normal}) {
    return Expanded(
      child: Container(
        alignment: alignment,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: 11.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table Header
        Row(
          children: [
            _buildHeaderCell('NO', alignment: Alignment.centerLeft),
            SizedBox(width: 14.w),

            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  'Product Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            _buildHeaderCell('Price', alignment: Alignment.centerRight),
            SizedBox(width: 10.w),
            _buildHeaderCell('Quantity', alignment: Alignment.center),
            SizedBox(width: 10.w),
            _buildHeaderCell('Total', alignment: Alignment.centerRight),
          ],
        ),
        Divider(height: 1.h, thickness: 0.5, color: const Color(0xFFE0E0E0)),

        // Table Data Rows
        ...items.map((item) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0.h),
            child: Row(
              children: [
                _buildDataCell(item.no, fontWeight: FontWeight.bold),
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                _buildDataCell(item.price, alignment: Alignment.centerRight),
                _buildDataCell('${item.quantity}', alignment: Alignment.center),
                _buildDataCell(item.total, alignment: Alignment.centerRight),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _SubtotalRow extends StatelessWidget {
  final String subtotal;

  const _SubtotalRow({required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Subtotal:',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          subtotal,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  void _onPayBill() {
    print('Paying bill...');
  }

  void _onExport() {
    print('Exporting invoice...');
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
            onPressed: _onPayBill,
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
                color: const Color(0xFF5BB450),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
