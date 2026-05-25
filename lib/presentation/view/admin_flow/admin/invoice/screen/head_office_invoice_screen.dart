import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/invoice/model/all_invoice_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/widget/search_filter.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:provider/provider.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../view_model/admin_invoice_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      // ignore: use_build_context_synchronously
      () => context.read<AdminInvoiceProvider>().getAllInvoice(),
    );
  }

  Timer? debouncer;
  String? loadingInvoiceId;

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  List<Invoices> _applyQueryFilter(List<Invoices> allInvoices) {
    if (context.read<AdminInvoiceProvider>().query.trim().isEmpty) {
      return allInvoices;
    }
    final q = context.read<AdminInvoiceProvider>().query.trim().toLowerCase();
    return allInvoices.where((invoice) {
      final branchName = (invoice.branchName ?? '').toLowerCase();
      return branchName.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminInvoiceProvider>(context);
    final invoiceData = provider.allInvoiceModel?.data?.invoices ?? [];
    final stats = provider.allInvoiceModel?.data?.stats;
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Invoice",
        profileImage: data?.avatar,
        notificationCount: notificationProvider.unreadCount,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        isIconPresent: true,
        useBottomNavBack: widget.fromBottomNav,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            /// ------------ Search Field ------------------------------
            SearchField(
              hintText: 'Search by branch name',
              text: provider.query,
              onChanged: (String value) {
                if (value.isEmpty) {
                  if (debouncer != null) {
                    debouncer!.cancel();
                  }
                  provider.setQuery('');
                } else {
                  debounce(() {
                    if (!mounted) return;
                    provider.setQuery(value);
                  }, duration: const Duration(milliseconds: 300));
                }
              },
            ),
            SizedBox(height: 16.h),

            /// ---------------Total / Paid / Pending Invoice ------------------
            if (stats != null)
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  _buildStatCard("Total Invoice", stats.totalInvoice ?? 0),
                  _buildStatCard("Paid Invoice", stats.paidInvoice ?? 0),
                  _buildStatCard("Pending Invoice", stats.pendingInvoice ?? 0),
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
                    context.read<AdminInvoiceProvider>().setSelectedPeriod(
                      value,
                    );
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
                  color: const Color(0xFFFFF5F5),
                  child: Row(
                    children: [
                      Text(
                        context.read<AdminInvoiceProvider>().selectedPeriod,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            /// --------------------- Orders List from server -----------------
            Expanded(
              child:
                  provider.isLoading && loadingInvoiceId == null
                      ? const Center(
                        child: SpinKitSpinningLines(
                          color: AppColors.primaryColor,
                          size: 50,
                        ),
                      )
                      : invoiceData.isEmpty
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48.sp,
                            color: Colors.grey.shade400,
                          ),
                          Text(
                            "No Invoice Found",
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                      : Builder(
                        builder: (context) {
                          final queryFilterOrders = _applyQueryFilter(
                            invoiceData,
                          );
                          return queryFilterOrders.isEmpty
                              ? Center(
                                child: Text(
                                  "No invoices found",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                itemCount: queryFilterOrders.length,
                                itemBuilder: (context, index) {
                                  final invoice = queryFilterOrders[index];
                                  final invoiceId = invoice.orderId ?? " ";

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
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
                                              height: double.infinity,
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
                                              child: GestureDetector(
                                                onTap:
                                                    loadingInvoiceId != null
                                                        ? null
                                                        : () async {
                                                          setState(() {
                                                            loadingInvoiceId =
                                                                invoiceId;
                                                          });
                                                          final response =
                                                              await provider
                                                                  .fetchInvoiceDetail(
                                                                    invoiceId,
                                                                  );
                                                          if (mounted) {
                                                            setState(() {
                                                              loadingInvoiceId =
                                                                  null;
                                                            });
                                                          }
                                                          if (context.mounted &&
                                                              response.success ==
                                                                  true) {
                                                            Navigator.pushNamed(
                                                              context,
                                                              RouteNames
                                                                  .adminInvoiceDetailScreen,
                                                              arguments:
                                                                  invoiceId,
                                                            );
                                                          }
                                                        },
                                                child: Center(
                                                  child:
                                                      loadingInvoiceId ==
                                                              invoiceId
                                                          ? const SpinKitSpinningLines(
                                                            color: Colors.white,
                                                            size: 16,
                                                          )
                                                          : Text(
                                                            "View",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 13.sp,
                                                            ),
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
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
      height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.authBodyTextColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
