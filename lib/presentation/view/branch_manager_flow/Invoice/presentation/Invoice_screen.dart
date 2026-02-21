import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../admin_flow/view_model/profile/change_pass_provider.dart';
import '../../../widget/custom_app_bar.dart';
import '../data/get_all_invoice_model.dart';
import '../view_model/get_all_invoice_viewmodel.dart';
import '../view_model/get_invoices_details_viewmodel.dart';

class InvoiceScreen extends StatefulWidget {
  final TextEditingController? controller;

  const InvoiceScreen({super.key, this.controller});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    // Fetch invoices after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetAllInvoiceProvider>().fetchAllInvoices();
    });
  }

  // Helper: Check if date is today
  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Helper: Check if date is this week
  bool _isThisWeek(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Helper: Check if date is this month
  bool _isThisMonth(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Filter invoices based on selected period
  List<Invoice> _getFilteredInvoices(List<Invoice> allInvoices) {
    if (allInvoices.isEmpty) return [];

    return allInvoices.where((invoice) {
      final date = DateTime.tryParse(invoice.createdAt ?? '');
      if (date == null) return false;

      switch (selectedPeriod) {
        case 'Today':
          return _isToday(date);
        case 'This Week':
          return _isThisWeek(date);
        case 'This Month':
          return _isThisMonth(date);
        default:
          return true;
      }
    }).toList();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown Date';
    final date = DateTime.tryParse(dateStr);
    return date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'Invalid Date';
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;

    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: CustomAppBar(profileImage: data?.avatar, notificationCount: 4),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 20.h),

            // Stats Cards
            Consumer<GetAllInvoiceProvider>(
              builder: (context, provider, child) {
                final stats = provider.invoiceResponse?.data.stats;
                final paid = stats?.paidInvoice.toString() ?? '0';
                final pending = stats?.pendingInvoice.toString() ?? '0';
                final total = stats?.totalInvoice.toString() ?? '0';

                final allInvoices =
                    provider.invoiceResponse?.data.invoices ?? [];
                final todayCount =
                    allInvoices
                        .where(
                          (i) => _isToday(DateTime.tryParse(i.createdAt ?? '')),
                        )
                        .length;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _periodCard(todayCount.toString()),
                        _summaryCard('Paid\nInvoice', paid),
                        _summaryCard('Pending\nInvoice', pending),
                      ].withSpace(15.w),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _summaryCard('Overdue Invoice', '0'),
                        // Update if API provides
                        _summaryCard('Total Invoice', total),
                      ].withSpace(15.w),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 20.h),

            // Title + Period Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Invoices',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1D1F2C),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      selectedPeriod,
                      style: const TextStyle(
                        color: Color(0xff4A4C56),
                        fontSize: 14,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      onSelected: (value) {
                        setState(() => selectedPeriod = value);
                      },
                      itemBuilder:
                          (_) =>
                              ['Today', 'This Week', 'This Month']
                                  .map(
                                    (e) =>
                                        PopupMenuItem(value: e, child: Text(e)),
                                  )
                                  .toList(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

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
                          const Icon(
                            Icons.error_outline,
                            size: 50,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(provider.errorMessage),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.fetchAllInvoices(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }

                  final allInvoices =
                      provider.invoiceResponse?.data.invoices ?? [];
                  final filteredInvoices = _getFilteredInvoices(allInvoices);

                  if (filteredInvoices.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            allInvoices.isEmpty
                                ? "No invoices available"
                                : "No invoices for $selectedPeriod",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = filteredInvoices[index];
                      final displayIndex = index + 1;
                      final date = _formatDate(invoice.createdAt);

                      return _buildInvoiceRow(
                        index: displayIndex,
                        date: date,
                        invoicId: invoice.orderId ?? 'N/A',
                        totalItems:
                            invoice.sku
                                .split(',')
                                .where((e) => e.isNotEmpty)
                                .length ??
                            0,
                        status: invoice.status ?? 'Unknown',
                        onViewPressed: () async {
                          await context
                              .read<GetInvoiceDetailViewmodel>()
                              .fetchInvoiceDetail(invoice.orderId);

                          if (mounted) {
                            Navigator.pushNamed(
                              context,
                              RouteNames.viewDetails,
                            );
                          }
                        },
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

  Widget _buildSearchBar() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: const Color(0xffEFEFEF),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Search invoices...',
          hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: Icon(Icons.tune, color: Colors.grey.shade600),
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
    final isSelected = selectedPeriod == 'Today';
    return GestureDetector(
      onTap: () => setState(() => selectedPeriod = 'Today'),
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
              'Today’s\nInvoices',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xff4A4C56)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow({
    required int index,
    required String date,
    required String invoicId,
    required int totalItems,
    required String status,
    required VoidCallback onViewPressed,
  }) {
    final statusColor =
        status.toLowerCase() == 'paid'
            ? Colors.green.shade600
            : status.toLowerCase() == 'pending'
            ? Colors.orange.shade600
            : Colors.red.shade600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 100.w,
            height: 36.h,
            decoration: const BoxDecoration(
              color: Color(0xffE8F5E9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                '$index. $date',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(
                //   'Order ID: $invoicId',
                //   style: const TextStyle(fontWeight: FontWeight.w600),
                // ),
                // const SizedBox(height: 4),
                Text(
                  'Items: $totalItems • Status: $status',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          Material(
            color: const Color(0xffE20613),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              onTap: onViewPressed,
              child: Container(
                width: 60.w,
                height: 36.h,
                alignment: Alignment.center,
                child: const Text(
                  'View',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension for spacing
extension SpaceBetween on List<Widget> {
  List<Widget> withSpace(double space) {
    if (length <= 1) return this;
    return expand((widget) => [widget, SizedBox(width: space)]).toList()
      ..removeLast();
  }
}
