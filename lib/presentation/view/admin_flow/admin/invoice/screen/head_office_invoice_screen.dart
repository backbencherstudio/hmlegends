import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../view_model/admin_invoic_provider.dart';

class HeadOfficeInvoiceScreen extends StatefulWidget {
  final bool fromBottomNav;

  const HeadOfficeInvoiceScreen({super.key, required this.fromBottomNav});

  @override
  State<HeadOfficeInvoiceScreen> createState() =>
      _HeadOfficeInvoiceScreenState();
}

class _HeadOfficeInvoiceScreenState extends State<HeadOfficeInvoiceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AdminInvoiceProvider>().getAllInvoice(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminInvoiceProvider>();
    final invoiceData = provider.allInvoiceModel?.data?.invoices ?? [];
    final stats = provider.allInvoiceModel?.data?.stats;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Invoice",
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        useBottomNavBack: widget.fromBottomNav,
      ),
      body: provider.allInvoiceModel == null
          ? const Center(child: CircularProgressIndicator())
          : invoiceData.isEmpty
          ? const Center(child: Text("No invoices available"))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  // Stats Wrap
                  if (stats != null)
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: [
                        _buildStatCard(
                          "Total Invoice",
                          stats.totalInvoice ?? 0,
                        ),
                        _buildStatCard("Paid Invoice", stats.paidInvoice ?? 0),
                        _buildStatCard(
                          "Pending Invoice",
                          stats.pendingInvoice ?? 0,
                        ),
                      ],
                    ),
                  SizedBox(height: 12.h),
                  // Invoice list
                  Expanded(
                    child: ListView.separated(
                      itemCount: invoiceData.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final invoice = invoiceData[index];
                        final fName = invoice.receiver?.firstName ?? "Unknown";
                        final lName = invoice.receiver?.lastName ?? "Unknown";
                        // final invoiceStatus = invoice.status ?? "Pending";
                        // final invoiceDate = invoice.createdAt ?? "";
                        // final invoiceId = invoice.id ?? "-";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 51,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xffD1E4C9),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text("${index + 1}"),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 59,
                                    vertical: 5.h,
                                  ),

                                  decoration: BoxDecoration(
                                    color: Color(0xffD1E4C9),
                                  ),
                                  child: Text("$fName $lName "),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "View",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper function to create a stat card
  Widget _buildStatCard(String title, int value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(title, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
