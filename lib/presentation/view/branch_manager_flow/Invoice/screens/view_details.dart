import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../core/constant/asset_path.dart';
import '../../../widget/simple_appbar.dart'; // Import for Key and specific widgets if needed

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
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Invoice From Section
                        const _AddressSection(
                          title: 'Invoice From',
                          name: 'JHON DOE',
                          address: '1550 Silky Blue Road San Francisco California',
                          phone: '(123) 123456-789',
                        ),
                        const Divider(height: 35, thickness: 1, color: Color(0xFFE0E0E0)),

                        // 2. Ship To Section
                        const _AddressSection(
                          title: 'Ship to',
                          name: 'JHON DOE',
                          address: '1550 Silky Blue Road San Francisco California',
                          phone: '(123) 123456-789',
                        ),
                        const Divider(height: 35, thickness: 1, color: Color(0xFFE0E0E0)),
                        const _DateInvoiceRow(
                          date: '20 APRIL 2025',
                          invoiceNo: 'FS618A',
                        ),
                        _InvoiceTable(items: mockItems),

                        const SizedBox(height: 20),
                        // 5. Subtotal
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1F2C),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff4A4C56),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF4A4C56),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          phone,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
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
              'DATE: $date' ,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff4A4C56),
              ),
            ),
            Text(
             'INVOICE NO: $invoiceNo',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff4A4C56),
              ),
                        ),
          ],
        ),
        Divider()
      ],
    );
  }
}
class _InvoiceTable extends StatelessWidget {
  final List<InvoiceItem> items;

   _InvoiceTable({required this.items});

  Widget _buildHeaderCell(String text, {Alignment alignment = Alignment.centerLeft}) {
    return Expanded(
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10.5,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {Alignment alignment = Alignment.centerLeft, FontWeight fontWeight = FontWeight.normal}) {
    return Expanded(
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: 11,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  List<int> flexes = [1, 5, 2, 2, 2];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table Header
        Row(
          children: [
            _buildHeaderCell('NO', alignment: Alignment.centerLeft),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'Product Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            _buildHeaderCell('Price', alignment: Alignment.centerRight),
SizedBox(width: 5,),
            _buildHeaderCell('Quantity', alignment: Alignment.center),

            _buildHeaderCell('Total', alignment: Alignment.centerRight),
          ],
        ),
        const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),

        // Table Data Rows
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                // NO (01, 02, ...)
                _buildDataCell(item.no, fontWeight: FontWeight.bold),
                // Product Name (Wider)
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // Price
                _buildDataCell(item.price, alignment: Alignment.centerRight),
                // Quantity
                _buildDataCell('${item.quantity}', alignment: Alignment.center),
                // Total
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
        const Text(
          'Subtotal:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          subtotal,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        // Add padding to align with the 'Total' column, matching the image.
        const SizedBox(width: 8),
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
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120,),

            ElevatedButton(
              onPressed: _onPayBill,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE20613),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 35),
                elevation: 5,
              ),
              child: const Text(
                'Pay bill',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(width: 20),

          TextButton.icon(
            onPressed: _onExport,
            icon: Image.asset('assets/icons/export.png',scale: 3.5,),
            label: const Text(
              'Export',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF5BB450), // Green color for the text
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
