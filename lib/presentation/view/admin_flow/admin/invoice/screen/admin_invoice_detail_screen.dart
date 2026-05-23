import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:hmlegends/presentation/widget/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/notification_admin/admin_notification_provider.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../model/invoice_detail_model.dart';
import '../view_model/admin_invoice_provider.dart';
import 'invoice_web_view_screen.dart';

class AdminInvoiceDetailScreen extends StatefulWidget {
  const AdminInvoiceDetailScreen({super.key});

  @override
  State<AdminInvoiceDetailScreen> createState() =>
      _AdminInvoiceDetailScreenState();

  static Widget _tableHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
    );
  }

  static Widget _tableCell(String text) {
    return Expanded(
      child: Center(child: Text(text, style: TextStyle(fontSize: 14.sp))),
    );
  }
}

class _AdminInvoiceDetailScreenState extends State<AdminInvoiceDetailScreen> {
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            return Center(child: CircularProgressIndicator());
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

          /// If safe → extract invoice
          final invoice = provider.invoiceDetailModel!.data;
          final allInVoices =
              provider.allInvoiceModel?.data?.invoices?.first.id;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
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
                      _addressCard(invoice!.creator),

                      SizedBox(height: 16),
                      _title("Ship to"),
                      _addressCard(invoice.receiver),

                      SizedBox(height: 20),
                      Divider(),

                      Text(
                        "DATE: ${_formatDate(invoice.createdAt)}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "SKU: ${invoice.sku}",
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
                SizedBox(height: 6.h),
                Divider(color: Color(0xFFA5A5AB), thickness: 1),
                SizedBox(height: 25.h),
                Text(
                  textAlign: TextAlign.center,
                  "Branch name's invoice is ready. Now you can send/export it",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4A4C56),
                  ),
                ),
                SizedBox(height: 20.h),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Row(
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
                            showDialog(
                              context: context,
                              builder:
                                  (context) => Dialog(
                                    child: Container(
                                      height: 300.h,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 99.w,
                                            height: 2.h,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFD2D2D2),
                                            ),
                                          ),
                                          SizedBox(height: 60.h),
                                          Text(
                                            "Type the email of the recipient",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF4A4C56),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 16.h),

                                          customTextFormField(
                                            hintText: 'Enter your email',
                                            controller: _controller,
                                            validator: emailValidator,
                                          ),
                                          SizedBox(height: 20.h),
                                          AuthButton(
                                            text: Text(
                                              'Send',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final res = await provider
                                                    .adminSendInvoice(
                                                      email: _controller.text,
                                                      allInVoices!,
                                                    );
                                                Utils.showToast(
                                                  msg: res.message,
                                                  backgroundColor: Colors.green,
                                                  textColor: Colors.white,
                                                );
                                              }
                                            },
                                            color: AppColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            );
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
                            Icon(
                              Icons.picture_as_pdf,
                              size: 24.sp,
                              color: Color(0xFF5BB450),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Export PDF",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Color(0xFF5BB450),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
        Text("${person.name} ", style: TextStyle(fontWeight: FontWeight.bold)),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdminInvoiceDetailScreen._tableHeader("NO"),
              AdminInvoiceDetailScreen._tableHeader("Product Name"),
              AdminInvoiceDetailScreen._tableHeader("Price"),
              AdminInvoiceDetailScreen._tableHeader("Qty"),
              AdminInvoiceDetailScreen._tableHeader("Total"),
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
                AdminInvoiceDetailScreen._tableCell("${i + 1}".padLeft(2, '0')),
                AdminInvoiceDetailScreen._tableCell(
                  item.product ?? "Peri Chicken Wrap",
                ),
                AdminInvoiceDetailScreen._tableCell("£${item.price}"),
                AdminInvoiceDetailScreen._tableCell("${item.quantity}"),
                AdminInvoiceDetailScreen._tableCell("£$total"),
              ],
            ),
          );
        }),
      ],
    );
  }
}
