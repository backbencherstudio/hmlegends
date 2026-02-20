import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/widget/search_filter.dart';
import 'package:provider/provider.dart';
import '../../../../widget/custom_app_bar.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../view_model/admin_invoice_provider.dart';

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

  String _selectedPeriod = 'Today';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminInvoiceProvider>();
    final invoiceData = provider.allInvoiceModel?.data?.invoices ?? [];
    final stats = provider.allInvoiceModel?.data?.stats;
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBar(profileImage: data?.avatar, notificationCount: 4),
      body:
          provider.allInvoiceModel == null
              ? const Center(child: CircularProgressIndicator())
              : invoiceData.isEmpty
              ? const Center(child: Text("No invoices available"))
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    /// ------------ Search Field ------------------------------
                    SearchField(hintText: ''),
                    SizedBox(height: 16.h),

                    /// ------------- Total / Paid / Pending Invoice -----------
                    if (stats != null)
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: [
                          _buildStatCard(
                            "Total Invoice",
                            stats.totalInvoice ?? 0,
                          ),
                          _buildStatCard(
                            "Paid Invoice",
                            stats.paidInvoice ?? 0,
                          ),
                          _buildStatCard(
                            "Pending Invoice",
                            stats.pendingInvoice ?? 0,
                          ),
                        ],
                      ),
                    SizedBox(height: 24.h),

                    /// ------------------ Total Orders List -------------------
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

                        PopupMenuButton<String>(
                          onSelected: (value) {
                            setState(() {
                              _selectedPeriod = value;
                            });
                          },
                          itemBuilder:
                              (context) => const [
                                PopupMenuItem(
                                  value: 'Today',
                                  child: Text('Today'),
                                ),
                                PopupMenuItem(
                                  value: 'This week',
                                  child: Text('This week'),
                                ),
                                PopupMenuItem(
                                  value: 'This month',
                                  child: Text('This month'),
                                ),
                              ],
                          color: const Color(0xFFFFF5F5),
                          child: Row(
                            children: [
                              Text(
                                _selectedPeriod,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    /// ------------------ Orders List from server -------------
                    Expanded(
                      child: ListView.separated(
                        itemCount: invoiceData.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final invoice = invoiceData[index];
                          final invoiceId = invoice.orderId ?? "-";

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFD1E4C9),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.r),
                                                  bottomLeft: Radius.circular(
                                                    8.r,
                                                  ),
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${index + 1}. ${invoice.branchName}",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Color(0xFF4A4C56),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              color: const Color(0xFFE6ECDE),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Total Units: ${invoice.totalQuantity}",
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: Color(0xFF4A4C56),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE20614),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                    8.r,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    8.r,
                                                  ),
                                                ),
                                              ),
                                              child: TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                8.r,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                8.r,
                                                              ),
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  "View",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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

  Widget _buildStatCard(String title, int value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
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
