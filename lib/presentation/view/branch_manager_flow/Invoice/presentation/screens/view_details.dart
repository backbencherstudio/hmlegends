import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utlis/utils.dart';
import '../../../../admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import '../../view_model/get_invoices_details_viewmodel.dart';
import '../../view_model/paid_payment_viewmodel.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/invoice/screen/invoice_web_view_screen.dart';

class ViewDetails extends StatelessWidget {
  const ViewDetails({super.key});

  String _formatDate(String isoString) {
    final date = DateTime.parse(isoString);
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: CustomAppBarTwo(
        title: 'Invoice',
        profileImage: data?.avatar,
        notificationCount: notificationProvider.unreadCount,
        colorMain: Colors.white,
        colorSpace: const Color(0xffFFF6F7),
        onProfileTap: () {
          context.read<BottomNavViewModel>().updateIndex(3);
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Consumer2<GetInvoiceDetailViewmodel, PayInvoiceViewModel>(
          builder: (context, invoiceVm, payVm, child) {
            if (invoiceVm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              );
            }

            final invoice = invoiceVm.invoiceDetail!.data!;
            final invoiceId = invoice.id ?? '';
            final isCurrentlyPaid = invoice.status?.toUpperCase() == 'PAID';

            // Combine both paid states: from API response or payment success
            final bool isPaid = isCurrentlyPaid || payVm.isPaid;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15.r),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 30.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _AddressSection(
                                    title: 'Invoice From',
                                    name: (invoice.creator?.name ?? '').trim(),
                                    address: invoice.creator?.address ?? '',
                                    phone: invoice.creator?.phoneNumber ?? '',
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  child:
                                      isPaid
                                          ? Container(
                                            key: const ValueKey('paid'),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 5.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF5BB450),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 25.w,
                                                  height: 25.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.red,
                                                    size: 22.w,
                                                  ),
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
                              color: const Color(0xFFE0E0E0),
                            ),
                            _AddressSection(
                              title: 'Ship to',
                              name: (invoice.receiver?.name ?? '').trim(),
                              address: invoice.receiver?.address ?? '',
                              phone: invoice.receiver?.phoneNumber ?? '',
                            ),

                            Divider(
                              height: 35.h,
                              thickness: 1,
                              color: const Color(0xFFE0E0E0),
                            ),

                            _DateInvoiceRow(
                              date: _formatDate(invoice.createdAt!),
                              invoiceNo: invoice.sku ?? 'N/A',
                            ),

                            SizedBox(height: 10.h),

                            _InvoiceTable(
                              items:
                                  invoice.order?.orderItems?.map((item) {
                                    final product = item.product;
                                    final qty = item.quantity ?? 0;
                                    final price = item.price ?? 0.0;
                                    final taxPercent = item.taxPercent ?? 0.0;
                                    return {
                                      'no':
                                          '${invoice.order!.orderItems!.indexOf(item) + 1}'
                                              .padLeft(2, '0'),
                                      'product_name':
                                          item.productName ?? product?.name ?? 'Unknown Product',
                                      'price': "$price",
                                      'quantity': qty,
                                      'tax_percent': '$taxPercent%',
                                      'total': qty * price,
                                    };
                                  }).toList() ??
                                  [],
                            ),

                            SizedBox(height: 20.h),

                            _SubtotalRow(
                              subtotal:
                                  '\$${invoice.order?.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// --------------- Bottom Action Bar --------------------------
                _BottomActionBar(
                  isPaid: isPaid,
                  isLoading: payVm.isLoading,
                  exportUrl: invoice.url,
                  // Inside your Consumer2 builder, update the onPaid callback like this:
                  onPaid:
                      isPaid
                          ? null
                          : () async {
                            await payVm.payInvoice(invoiceId);

                            if (payVm.error != null) {
                              Utils.showToast(
                                msg: payVm.error!,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            } else if (payVm.isPaid) {
                              // Show success message from API response
                              final successMsg =
                                  payVm.lastPaymentResponse?.message ??
                                  "Invoice paid successfully!";

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(successMsg)),
                                    ],
                                  ),
                                ),
                              );

                              // Optional: Refresh invoice details to reflect new status
                              // await invoiceVm.fetchInvoiceDetails(invoiceId);
                            }
                          },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// === Reusable Widgets (unchanged except BottomActionBar) ===

class _AddressSection extends StatelessWidget {
  final String title, name, address, phone;

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
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          address,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF616161)),
        ),
        SizedBox(height: 5.h),
        Text(
          phone,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF616161)),
        ),
      ],
    );
  }
}

class _DateInvoiceRow extends StatelessWidget {
  final String date, invoiceNo;

  const _DateInvoiceRow({required this.date, required this.invoiceNo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Date: $date',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          'Invoice No: $invoiceNo',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _InvoiceTable extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _InvoiceTable({required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: const Color(0xFFE0E0E0)),
        columnWidths: {
          0: FixedColumnWidth(40.w),
          1: FixedColumnWidth(180.w),
          2: FixedColumnWidth(80.w),
          3: FixedColumnWidth(90.w), // Increased space for Quantity
          4: FixedColumnWidth(70.w),
          5: FixedColumnWidth(80.w),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
            children:
                ['No', 'Product Name', 'Price', 'Quantity', 'Tax', 'Total']
                    .map(
                      (header) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        child: Text(
                          header,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          ...items.map(
            (item) => TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Text(item['no']),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Text(item['product_name'] ?? 'N/A'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Text('\$${item['price']}'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Text('${item['quantity']}'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Text('${item['tax_percent']}'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Text('\$${item['total']}'),
                ),
              ],
            ),
          ),
        ],
      ),
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
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// ---------------- Updated Bottom Action Bar with loading state --------------
class _BottomActionBar extends StatefulWidget {
  final bool isPaid;
  final bool isLoading;
  final VoidCallback? onPaid;
  final String? exportUrl;

  const _BottomActionBar({
    required this.isPaid,
    required this.isLoading,
    required this.onPaid,
    this.exportUrl,
  });

  @override
  State<_BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<_BottomActionBar> {
  bool isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!widget.isPaid)
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : widget.onPaid,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child:
                      widget.isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            'Pay Bill',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),

          if (!widget.isPaid) SizedBox(width: 15.w),

          // Export button always visible
          TextButton.icon(
            onPressed: isExporting
                ? null
                : () async {
                    if (widget.exportUrl != null && widget.exportUrl!.isNotEmpty) {
                      setState(() {
                        isExporting = true;
                      });
                      await openInvoice(widget.exportUrl!);
                      if (mounted) {
                        setState(() {
                          isExporting = false;
                        });
                      }
                    }
                  },
            icon: isExporting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: SpinKitThreeBounce(
                      duration: Duration(milliseconds: 300),
                      size: 10,
                      color: Color(0xFF5BB450),
                    ),
                  )
                : Image.asset('assets/icons/export.png', scale: 3),
            label: Text(
              isExporting ? 'Exporting...' : 'Export',
              style: TextStyle(
                fontSize: 20.sp,
                color: const Color(0xFF5BB450),
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF5BB450),
                decorationThickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
