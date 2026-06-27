import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/notification_admin/admin_notification_provider.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../model/invoice_detail_model.dart';
import '../view_model/admin_invoice_provider.dart';
import 'invoice_web_view_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminInvoiceDetailScreen extends StatefulWidget {
  const AdminInvoiceDetailScreen({super.key});

  @override
  State<AdminInvoiceDetailScreen> createState() =>
      _AdminInvoiceDetailScreenState();


}

class _AdminInvoiceDetailScreenState extends State<AdminInvoiceDetailScreen> {
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy').format(dateTime).toUpperCase();
    } catch (e) {
      return dateString.toUpperCase();
    }
  }

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSendInvoiceBottomSheet(
    BuildContext context, 
    String invoiceId, 
    AdminInvoiceProvider provider,
    {String? receiverEmail}
  ) {
    if (receiverEmail != null && receiverEmail.isNotEmpty) {
      _controller.text = receiverEmail;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 48.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2D2D2),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Title
                  Text(
                    "Type the email of the recipient.",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF4A4C56),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Email Text Field
                  TextFormField(
                    controller: _controller,
                    validator: emailValidator,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "branch01@gmail.com",
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFFA5A5AB),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w, 
                        vertical: 14.h
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE20614),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final navigator = Navigator.of(context);
                          final res = await provider.adminSendInvoice(
                            invoiceId,
                            email: _controller.text,
                          );
                          navigator.pop(); // Close bottomsheet
                          _controller.clear();
                          Utils.showToast(
                            msg: res.message,
                            backgroundColor: res.success ? Colors.green : Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _exportPdfButton(InvoiceData invoice) {
    return GestureDetector(
      onTap: invoice.url.isEmpty
          ? () {
              Utils.showToast(
                msg: "PDF URL is not available yet",
                backgroundColor: Colors.orange,
                textColor: Colors.white,
              );
            }
          : () {
              openInvoice(invoice.url);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE8E6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: Color(0xffE20614),
              size: 22,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            "Export pdf",
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xffE20614),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBarTwo(
        title: "Invoice",
        profileImage: '${data?.avatar}',
        notificationCount: notificationProvider.unreadCount,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),
      body: Consumer<AdminInvoiceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: SpinKitSpinningLines(
                color: AppColors.primaryColor,
                size: 50,
              ),
            );
          }

          if (provider.invoiceDetailModel == null ||
              provider.invoiceDetailModel!.data == null) {
            return Center(
              child: Text(
                "No invoice data found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final invoice = provider.invoiceDetailModel!.data;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("Invoice From"),
                      SizedBox(height: 4.h),
                      _addressCard(invoice!.creator),
                      SizedBox(height: 12.h),
                      const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                      SizedBox(height: 12.h),
                      _title("Ship to"),
                      SizedBox(height: 4.h),
                      _addressCard(invoice.receiver),
                      SizedBox(height: 20.h),
                      
                      const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "DATE: ${_formatDate(invoice.createdAt)}",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4A4C56),
                              ),
                            ),
                            Text(
                              "INVOICE NO: ${invoice.sku.toUpperCase()}",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4A4C56),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                      SizedBox(height: 16.h),
                      
                      _itemsTable(invoice.order.orderItems),
                      const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                      
                      Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Subtotal:   ",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xFF777980),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "£${invoice.order.totalAmount}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                
                Text(
                  "${invoice.receiver.name}'s invoice is ready. Now you can\nsend/export it.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4A4C56),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24.h),
                
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffE20614),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            _showSendInvoiceBottomSheet(context, invoice.id, provider, receiverEmail: invoice.receiver.email);
                          },
                          child: Text(
                            "Send Invoice",
                            style: TextStyle(
                              fontSize: 16.sp, 
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _exportPdfButton(invoice),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }

  // Section Title
  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp, 
        fontWeight: FontWeight.bold,
        color: const Color(0xFF777980),
      ),
    );
  }

  // Address Card
  Widget _addressCard(Person person) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          person.name.toUpperCase(), 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          person.address,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF4A4C56),
            height: 1.3,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          person.phoneNumber,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF4A4C56),
          ),
        ),
      ],
    );
  }

  // Helper Headers
  static Widget _tableHeader(String text, {required int flex, TextAlign align = TextAlign.center}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 14.sp,
          color: const Color(0xFF4A4C56),
        ),
        textAlign: align,
      ),
    );
  }

  static Widget _tableCell(String text, {required int flex, TextAlign align = TextAlign.center, FontWeight? fontWeight}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF4A4C56),
          fontWeight: fontWeight,
        ),
        textAlign: align,
      ),
    );
  }

  // Items Table
  Widget _itemsTable(List<OrderItem> items) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              _tableHeader("NO", flex: 1, align: TextAlign.left),
              _tableHeader("Product Name", flex: 4, align: TextAlign.left),
              _tableHeader("Price", flex: 2, align: TextAlign.center),
              _tableHeader("Quantity", flex: 2, align: TextAlign.center),
              _tableHeader("Total", flex: 2, align: TextAlign.right),
            ],
          ),
        ),
        const Divider(color: Color(0xFFE5E5E5), thickness: 1),
        ...List.generate(items.length, (i) {
          final item = items[i];
          final total = item.price * item.quantity;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                _tableCell("${i + 1}".padLeft(2, '0'), flex: 1, align: TextAlign.left),
                _tableCell(item.product ?? "Product Name", flex: 4, align: TextAlign.left),
                _tableCell("£${item.price}", flex: 2, align: TextAlign.center),
                _tableCell("${item.quantity}", flex: 2, align: TextAlign.center),
                _tableCell("£$total", flex: 2, align: TextAlign.right),
              ],
            ),
          );
        }),
        SizedBox(height: 8.h),
      ],
    );
  }
}
