import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/asset_path.dart';
import '../../../widget/simple_appbar.dart';
import '../data/get_all_invoice_model.dart';
import '../view_model/get_all_invoice_viewmodel.dart';
import '../view_model/get_invoices_details_viewmodel.dart'; // Adjust path

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetAllInvoiceProvider>().fetchAllInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: const SimpleAppbar(
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        title: 'Invoice',
        navigationType: NavigationType.none,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 20.h),

            Consumer<GetAllInvoiceProvider>(
              builder: (context, provider, child) {
                final stats = provider.invoiceResponse?.data?.stats;

                final paid = stats?.paidInvoice?.toString() ?? '';
                final pending = stats?.pendingInvoice?.toString() ?? '';
                final total = stats?.totalInvoice?.toString() ?? '';

                final todayCount =
                    provider.invoiceResponse?.data?.invoices
                        ?.where((i) => _isToday(i.createdAt))
                        .length
                        .toString() ??
                    '';

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _periodCard(todayCount),
                        _summaryCard('Paid\nInvoice', paid),
                        _summaryCard('Pending\nInvoice', pending),
                      ].withSpace(15),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _summaryCard('Overdue Invoice', '0'),
                        _summaryCard('Total Invoice', total),
                      ].withSpace(15),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 20.h),

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
                      onSelected: (value) =>
                          setState(() => selectedPeriod = value),
                      itemBuilder: (_) => ['Today', 'This Week', 'This Month']
                          .map((e) => PopupMenuItem(value: e, child: Text(e)))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

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
                            size: 30,
                            color: Colors.red,
                          ),
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
                      provider.invoiceResponse?.data?.invoices ?? [];
                  final filteredInvoices = _filterInvoicesByPeriod(
                    allInvoices,
                    selectedPeriod,
                  );

                  if (filteredInvoices.isEmpty) {
                    return const Center(child: Text("No invoices found"));
                  }

                  return ListView.builder(
                    itemCount: filteredInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = filteredInvoices[index];
                      final displayIndex = index + 1;
                      final date = _formatDate(invoice.createdAt);

                      return _buildInvoiceRow(
                        index: displayIndex,
                        date: date,
                        invoicId: invoice.orderId ?? '',
                        totalItems: invoice.sku?.split(',').length ?? 1,
                        status: invoice.status ?? 'Unknown',
                        onViewPressed: () async {
                          debugPrint(
                            '-------order id------- : ${invoice.orderId}',
                          );


                          await context
                              .read<GetInvoiceDetailViewmodel>()
                              .fetchInvoiceDetail(invoice.orderId ?? '');

                          if (invoice.orderId != null) {
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

  List<Invoices> _filterInvoicesByPeriod(
    List<Invoices> invoices,
    String period,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return invoices.where((invoice) {
      if (invoice.createdAt == null) return false;
      final invoiceDate = DateTime.tryParse(invoice.createdAt!) ?? today;

      switch (period) {
        case 'Today':
          return invoiceDate.year == today.year &&
              invoiceDate.month == today.month &&
              invoiceDate.day == today.day;
        case 'This Week':
          final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
          return invoiceDate.isAfter(
                startOfWeek.subtract(const Duration(days: 1)),
              ) &&
              invoiceDate.isBefore(startOfWeek.add(const Duration(days: 7)));
        case 'This Month':
          return invoiceDate.year == today.year &&
              invoiceDate.month == today.month;
        default:
          return true;
      }
    }).toList();
  }

  bool _isToday(String? dateStr) {
    if (dateStr == null) return false;
    final date = DateTime.tryParse(dateStr);
    if (date == null) return false;
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown Date';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return 'Invalid Date';
    return DateFormat('dd/MM/yyyy').format(date);
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
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 22.w,
          ),
          suffixIcon: Icon(Icons.tune, color: Colors.grey.shade600, size: 22.w),
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
            color: Colors.grey.shade100,
            blurRadius: 4,
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
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xff1D1F2C),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xff4A4C56)),
          ),
        ],
      ),
    );
  }

  Widget _periodCard(String count) {
    final isToday = selectedPeriod == 'Today';
    return GestureDetector(
      onTap: () => setState(() => selectedPeriod = 'Today'),
      child: Container(
        height: 90.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isToday ? const Color(0xffE20613) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xff1D1F2C),
              ),
            ),
            const Text(
              'Today’s\nInvoices',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xff4A4C56)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow({
    required int index,
    required String invoicId,
    required String date,
    required int totalItems,
    required String status,
    required VoidCallback onViewPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 35,
                color: Colors.lightGreen.shade200,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  '$index. $date',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: 35,
                color: Colors.lightGreen.shade50,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Total Items: $totalItems',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Material(
                color: const Color(0xffE20613),
                child: InkWell(
                  onTap: onViewPressed,
                  child: const SizedBox(
                    height: 35,
                    child: Center(
                      child: Text(
                        'View',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
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
  }
}

extension SpaceBetween on List<Widget> {
  List<Widget> withSpace(double space) =>
      expand((w) => [w, SizedBox(width: space)]).toList()..removeLast();
}
