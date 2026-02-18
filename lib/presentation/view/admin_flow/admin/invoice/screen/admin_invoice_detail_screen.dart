import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/invoice_detail_model.dart';
import '../view_model/admin_invoice_provider.dart';
import 'iInvoiceWebViewScreen.dart';

class AdminInvoiceDetailScreen extends StatelessWidget {
  const AdminInvoiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text("Invoice")),
      body: Consumer<AdminInvoiceProvider>(
        builder: (context, provider, _) {

          /// ------------------------------
          /// ------------------------------
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          /// ----------------------------------------------
          /// ----------------------------------------------
          if (provider.invoiceDetailModel == null ||
              provider.invoiceDetailModel!.data == null) {
            return Center(
              child: Text(
                "No invoice data found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          /// If safe → extract invoice
          final invoice = provider.invoiceDetailModel!.data;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("Invoice From"),
                      _addressCard(invoice!.creator),

                      SizedBox(height: 16),
                      _title("Ship to"),
                      _addressCard(invoice.receiver),

                      SizedBox(height: 20),
                      Divider(),

                      Text(
                        "DATE: ${invoice.createdAt}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "INVOICE NO: ${invoice.id}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),

                      SizedBox(height: 10),
                      _itemsTable(invoice.order.orderItems),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Subtotal:   £${invoice.order.totalAmount}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),
                Text(
                  "Branch name’s invoice is ready. Now you can send/export it.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffE20614),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          openInvoice(invoice.url);
                        },
                        child: Text(
                          "Send Invoice",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        openInvoice(invoice.url);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf),
                          Text("Export PDF"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Section Title
  Widget _title(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Address Card
  Widget _addressCard(Person person) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${person.firstName} ${person.lastName}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(person.address),
        SizedBox(height: 2),
        Text("(${person.phoneNumber})"),
      ],
    );
  }

  // Items Table
  Widget _itemsTable(List<OrderItem> items) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _tableHeader("NO"),
              _tableHeader("Product Name"),
              _tableHeader("Price"),
              _tableHeader("Qty"),
              _tableHeader("Total"),
            ],
          ),
        ),
        Divider(),

        ...List.generate(items.length, (i) {
          final item = items[i];
          final total = item.price * item.quantity;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                _tableCell("${i + 1}".padLeft(2, '0')),
                _tableCell(item.product.name),
                _tableCell("£${item.price}"),
                _tableCell("${item.quantity}"),
                _tableCell("£$total"),
              ],
            ),
          );
        }),
      ],
    );
  }

  static Widget _tableHeader(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  static Widget _tableCell(String text) {
    return Expanded(
      child: Text(text, style: TextStyle(fontSize: 14)),
    );
  }
}
