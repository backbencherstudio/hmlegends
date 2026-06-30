import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/widget/search_filter.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../admin_flow/view_model/profile/change_pass_provider.dart';
import '../view_model/get_all_invoice_viewmodel.dart';
import '../view_model/get_invoices_details_viewmodel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InvoiceScreen extends StatefulWidget {
  final TextEditingController? controller;

  const InvoiceScreen({super.key, this.controller});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<GetAllInvoiceProvider>().updatedPeriod('Today');
    });
    super.initState();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown Date';
    final date = DateTime.tryParse(dateStr);
    return date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'Invalid Date';
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

  void _handleBack(BuildContext context) {
    context.read<BottomNavViewModel>().updateIndex(0);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final getAllInvoices = Provider.of<GetAllInvoiceProvider>(context);
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );

    final stats = getAllInvoices.invoiceResponse?.data.stats;
    final paid = stats?.paidInvoice.toString() ?? '0';
    final pending = stats?.pendingInvoice.toString() ?? '0';
    final total = stats?.totalInvoice.toString() ?? '0';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFFF6F7),
        appBar: CustomAppBarTwo(
          title: 'Invoice',
          profileImage: data?.avatar,
          notificationCount: notificationProvider.unreadCount,
          colorMain: Colors.white,
          colorSpace: const Color(0xffFFF6F7),
          onBackTap: () => _handleBack(context),
          onProfileTap: () {
            context.read<BottomNavViewModel>().updateIndex(3);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchField(
                hintText: 'Search by branch name',
                text: getAllInvoices.query,
                onChanged: (String value) {
                  if (value.isEmpty) {
                    if (debouncer != null) {
                      debouncer!.cancel();
                    }
                    getAllInvoices.setQuery('');
                  } else {
                    debounce(() {
                      if (!mounted) return;
                      getAllInvoices.setQuery(value);
                    }, duration: const Duration(milliseconds: 300));
                  }
                },
              ),
              SizedBox(height: 20.h),

              /// ----------------- Stats Cards ------------------------------
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _periodCard(paid),
                      _summaryCard('Pending\nInvoice', pending),
                      _summaryCard('Total\nInvoice', total),
                    ].withSpace(15.w),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              ///------------------ Title + Period Selector ------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Invoices',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1D1F2C),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        getAllInvoices.selectedPeriod,
                        style: TextStyle(
                          color: Color(0xff4A4C56),
                          fontSize: 14.sp,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        onSelected: (value) {
                          context.read<GetAllInvoiceProvider>().updatedPeriod(
                            value,
                          );
                        },
                        itemBuilder:
                            (_) =>
                                ['Today', 'This Week', 'This Month']
                                    .map(
                                      (e) => PopupMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Invoices List
              Expanded(
                child: Consumer<GetAllInvoiceProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.errorMessage.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 50.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16.h),
                            Text(provider.errorMessage),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () => provider.fetchAllInvoices(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }

                    final rawInvoices =
                        provider.invoiceResponse?.data.invoices ?? [];
                    final query = provider.query.trim().toLowerCase();
                    final allInvoices =
                        query.isEmpty
                            ? rawInvoices
                            : rawInvoices
                                .where(
                                  (invoice) => invoice.branchName
                                      .toLowerCase()
                                      .contains(query),
                                )
                                .toList();

                    if (allInvoices.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              rawInvoices.isEmpty
                                  ? "No invoices available"
                                  : query.isNotEmpty
                                  ? "No matching invoices found"
                                  : "No invoices for ${provider.selectedPeriod}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: allInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = allInvoices[index];
                        final date = _formatDate(invoice.createdAt);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
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
                                              "${index + 1}. $date",
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
                                                topRight: Radius.circular(8.r),
                                                bottomRight: Radius.circular(
                                                  8.r,
                                                ),
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: loadingInvoiceId != null
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        loadingInvoiceId =
                                                            invoice.orderId;
                                                      });
                                                      final success = await context
                                                          .read<
                                                            GetInvoiceDetailViewmodel
                                                          >()
                                                          .fetchInvoiceDetail(
                                                            invoice.orderId,
                                                          );
                                                      if (mounted) {
                                                        setState(() {
                                                          loadingInvoiceId =
                                                              null;
                                                        });
                                                      }
                                                      if (success &&
                                                          context.mounted) {
                                                        Navigator.pushNamed(
                                                          context,
                                                          RouteNames.viewDetails,
                                                          arguments:
                                                              invoice.orderId,
                                                        );
                                                      }
                                                    },
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
                                              child: loadingInvoiceId ==
                                                      invoice.orderId
                                                  ? const SpinKitSpinningLines(
                                                      color: Colors.white,
                                                      size: 16,
                                                    )
                                                  : Text(
                                                      "View",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String count) {
    return Container(
      height: 90.h,
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff1D1F2C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xff4A4C56)),
          ),
        ],
      ),
    );
  }

  Widget _periodCard(String count) {
    final isSelected =
        context.watch<GetAllInvoiceProvider>().selectedPeriod == 'Today';
    return GestureDetector(
      onTap: () {
        context.read<GetAllInvoiceProvider>().updatedPeriod('today');
      },
      child: Container(
        height: 90.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xffE20613) : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff1D1F2C),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Paid\nInvoices',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xff4A4C56)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildInvoiceRow({
  //   required int index,
  //   required String date,
  //   required String invoiceId,
  //   required String totalItems,
  //   required VoidCallback onViewPressed,
  // }) {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 100.w,
  //           height: 36.h,
  //           decoration: const BoxDecoration(
  //             color: Color(0xffE8F5E9),
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(12),
  //               bottomLeft: Radius.circular(12),
  //             ),
  //           ),
  //           child: Center(
  //             child: Text(
  //               '$index. $date',
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFF1B5E20),
  //                 fontSize: 13,
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               // Text(
  //               //   'Order ID: $invoicId',
  //               //   style: const TextStyle(fontWeight: FontWeight.w600),
  //               // ),
  //               // const SizedBox(height: 4),
  //               Text(
  //                 'Total Items: $totalItems'.padLeft(2, '0'),
  //                 style: TextStyle(color: Colors.black),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Material(
  //           color: const Color(0xffE20613),
  //           borderRadius: const BorderRadius.only(
  //             topRight: Radius.circular(12),
  //             bottomRight: Radius.circular(12),
  //           ),
  //           child: InkWell(
  //             borderRadius: const BorderRadius.only(
  //               topRight: Radius.circular(12),
  //               bottomRight: Radius.circular(12),
  //             ),
  //             onTap: onViewPressed,
  //             child: Container(
  //               width: 60.w,
  //               height: 36.h,
  //               alignment: Alignment.center,
  //               child: const Text(
  //                 'View',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// Extension for spacing
extension SpaceBetween on List<Widget> {
  List<Widget> withSpace(double space) {
    if (length <= 1) return this;
    return expand((widget) => [widget, SizedBox(width: space)]).toList()
      ..removeLast();
  }
}
