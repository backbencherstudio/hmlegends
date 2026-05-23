import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/invoice/model/all_invoice_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/invoice/view_model/admin_invoice_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../../widget/search_filter.dart';
import '../widget/invoice_summary_card.dart';

class InvoiceStatusScreen extends StatefulWidget {
  const InvoiceStatusScreen({super.key});

  @override
  State<InvoiceStatusScreen> createState() => _InvoiceStatusScreenState();
}

class _InvoiceStatusScreenState extends State<InvoiceStatusScreen> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<AdminInvoiceProvider>(
        // ignore: use_build_context_synchronously
        context,
        listen: false,
      ).getAllInvoice();
    });
    super.initState();
  }

  String selectedPeriod = 'Today';

  /// -------------------- Apply Query Filter variables ------------------------
  List<Invoices> invoices = [];
  String query = '';
  Timer? debouncer;

  /// ------------------------ Debounce ---------------------------------------
  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  /// ------------------------ Apply Query Filter -----------------------------
  List<Invoices> _applyQueryFilter(List<Invoices> invoices) {
    if (query.trim().isEmpty) return invoices;
    final q = query.trim().toLowerCase();
    return invoices.where((invoice) {
      final name = invoice.branchName ?? '';
      return name.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    final notification = notificationProvider.adminNotificationModel?.data;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Invoice status",
        profileImage: '${data?.avatar}',
        notificationCount: notification?.length ?? 0,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
        child: Consumer<AdminInvoiceProvider>(
          builder: (context, provider, child) {
            final data = provider.allInvoiceModel?.data;
            final invoices = data?.invoices ?? [];
            final stats = data?.stats;

            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (invoices.isEmpty) {
              return const Center(child: Text("No Invoice Available"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchField(
                  hintText: 'Search by branch name',
                  text: query,
                  onChanged: (String value) {
                    if (value.isEmpty) {
                      if (debouncer != null) {
                        debouncer!.cancel();
                      }
                      setState(() {
                        query = '';
                      });
                    } else {
                      debounce(() {
                        if (!mounted) return;
                        setState(() {
                          query = value;
                        });
                      }, duration: const Duration(milliseconds: 300));
                    }
                  },
                ),
                SizedBox(height: 20.h),

                /// ---------------- Summary Boxes ----------------
                if (stats != null)
                  Row(
                    children: [
                      Expanded(
                        child: InvoiceSummaryCard(
                          title: "Total Invoices",
                          value: stats.totalInvoice.toString(),
                          isHighlighted: true,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: InvoiceSummaryCard(
                          title: "Pending Invoices",
                          value: stats.pendingInvoice.toString(),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: InvoiceSummaryCard(
                          title: "Paid Invoices",
                          value: stats.paidInvoice.toString(),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 28.h),

                /// ---------------- Header Row ----------------
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
                          selectedPeriod = value;
                        });
                      },
                      itemBuilder:
                          (context) => const [
                            PopupMenuItem(value: 'Today', child: Text('Today')),
                            PopupMenuItem(
                              value: 'This week',
                              child: Text('This week'),
                            ),
                            PopupMenuItem(
                              value: 'This month',
                              child: Text('This month'),
                            ),
                          ],
                      color: Color(0xFFFFF5F5),
                      child: Row(
                        children: [
                          Text(
                            selectedPeriod,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                /// ---------------- Invoice List ----------------
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final filteredInvoices = _applyQueryFilter(invoices);
                      return filteredInvoices.isEmpty
                          ? Center(
                            child: Text(
                              "No Invoice Available",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: filteredInvoices.length,
                            padding: EdgeInsets.only(bottom: 8.h),
                            itemBuilder: (context, index) {
                              final items = filteredInvoices[index];

                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: SizedBox(
                                  height: 34.h,
                                  child: Row(
                                    children: [
                                      /// Branch Name
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD1E4C9),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.r),
                                              bottomLeft: Radius.circular(8.r),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${index + 1}. ${items.branchName ?? ''}",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    AppColors.authBodyTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// Total Units
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          color: const Color(0xFFE6ECDE),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Total Units: ${items.totalQuantity ?? 0}",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color:
                                                    AppColors.authBodyTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// Action View Button
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () async {
                                            Navigator.pushNamed(
                                              context,
                                              RouteNames
                                                  .adminInvoiceDetailScreen,
                                            );
                                            await provider.fetchInvoiceDetail(
                                              items.orderId!,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE20614),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(8.r),
                                                bottomRight: Radius.circular(
                                                  8.r,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "View",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.sp,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
