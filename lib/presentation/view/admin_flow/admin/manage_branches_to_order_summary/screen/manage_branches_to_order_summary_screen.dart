import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/single_branch_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:provider/provider.dart';

import '../../../../widget/custom_app_bar_2.dart';
import '../../manage_branches/view_model/manage_branch_provider.dart';

class ManageBranchesToOrderSummaryScreen extends StatefulWidget {
  final String? managerId;

  const ManageBranchesToOrderSummaryScreen({super.key, this.managerId});

  @override
  State<ManageBranchesToOrderSummaryScreen> createState() =>
      _ManageBranchesToOrderSummaryScreenState();
}

class _ManageBranchesToOrderSummaryScreenState
    extends State<ManageBranchesToOrderSummaryScreen> {
  String selectedPeriod = 'Today';
  final Set<int> _expandedOrders = {};

  static const _periodApiMap = {
    'Today': 'today',
    'This Week': 'week',
    'This Month': 'month',
  };

  String _resolveImageUrl(String raw) {
    if (raw.isEmpty) return '';
    if (raw.startsWith('http')) {
      return '${ApiEndpoints.baseUrl}${Uri.parse(raw).path}';
    }
    if (raw.startsWith('/')) return '${ApiEndpoints.baseUrl}$raw';
    return '${ApiEndpoints.baseUrl}/$raw';
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      return '$d/$m/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  void _fetchData({String? period}) {
    final apiPeriod = _periodApiMap[period ?? selectedPeriod] ?? 'today';
    Provider.of<ManageBranchProvider>(context, listen: false)
        .getSingleBranch(widget.managerId ?? '', period: apiPeriod);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    final managerBranchProvider = Provider.of<ManageBranchProvider>(context);
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final notificationProvider = Provider.of<AdminNotificationProvider>(context);

    final profile = profileProvider.adminInfoModel?.data;

    final singleBranch = managerBranchProvider.singleBranchModel?.data;
    final orders = singleBranch?.orders ?? <Orders>[];
    final List<OrderItems> allOrderItems = orders
        .expand<OrderItems>((o) => o.orderItems ?? <OrderItems>[])
        .toList();

    final avatar = singleBranch?.avatar ?? '';
    final String fullAvatarUrl;
    if (avatar.isEmpty) {
      fullAvatarUrl = '';
    } else if (avatar.startsWith('http')) {
      fullAvatarUrl = '${ApiEndpoints.baseUrl}${Uri.parse(avatar).path}';
    } else if (avatar.startsWith('/')) {
      fullAvatarUrl = '${ApiEndpoints.baseUrl}$avatar';
    } else {
      fullAvatarUrl = '${ApiEndpoints.baseUrl}/storage/avatar/$avatar';
    }

    final isToday = selectedPeriod == 'Today';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),

      appBar: CustomAppBarTwo(
        title: "Order Summary",
        profileImage: profile?.avatar ?? '',
        notificationCount: notificationProvider.unreadCount,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),

      body: managerBranchProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Branch Info Card
                  Container(
                    margin: EdgeInsets.only(bottom: 14.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: fullAvatarUrl.isNotEmpty
                              ? Image.network(
                                  fullAvatarUrl,
                                  height: 65.h,
                                  width: 65.h,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return SizedBox(
                                      height: 65.h,
                                      width: 65.h,
                                      child: const Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    );
                                  },
                                  errorBuilder: (c, o, s) => SizedBox(
                                    height: 65.h,
                                    width: 65.h,
                                    child: const Icon(Icons.image_not_supported),
                                  ),
                                )
                              : SizedBox(
                                  height: 65.h,
                                  width: 65.h,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                singleBranch?.name ?? 'N/A',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: AppColors.authHeaderTextColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Image.asset(AssetPaths.locationIcon, height: 20.h),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      singleBranch?.address ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.authBodyTextColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F5E6),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            singleBranch?.status ?? 'N/A',
                            style: TextStyle(
                              color: const Color(0xFF5BB450),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isToday ? 'Total Items' : 'Total Orders',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            selectedPeriod = value;
                            _expandedOrders.clear();
                          });
                          _fetchData(period: value);
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'Today', child: Text('Today')),
                          PopupMenuItem(value: 'This Week', child: Text('This Week')),
                          PopupMenuItem(value: 'This Month', child: Text('This Month')),
                        ],
                        color: const Color(0xFFFFF5F5),
                        child: Row(
                          children: [
                            Text(
                              selectedPeriod,
                              style: TextStyle(fontSize: 13.sp),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Divider(color: const Color(0xFFEFEFEF), thickness: 1, height: 16.h),
                  SizedBox(height: 6.h),

                  /// Content
                  Expanded(
                    child: isToday
                        ? _buildTodayList(allOrderItems)
                        : _buildGroupedOrders(orders),
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
    );
  }

  // ── Today: flat numbered list ──────────────────────────────────────────────

  Widget _buildTodayList(List<OrderItems> items) {
    if (items.isEmpty) return _emptyState();
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          Divider(color: const Color(0xFFEFEFEF), thickness: 1, height: 20.h),
      itemBuilder: (context, index) => _buildItemRow(index + 1, items[index]),
    );
  }

  // ── This Week / This Month: grouped by order date ─────────────────────────

  Widget _buildGroupedOrders(List<Orders> orders) {
    if (orders.isEmpty) return _emptyState();
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isExpanded = _expandedOrders.contains(index);
        final items = order.orderItems ?? <OrderItems>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Order header row
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedOrders.remove(index);
                  } else {
                    _expandedOrders.add(index);
                  }
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.authBodyTextColor,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        _formatDate(order.createdAt),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.authHeaderTextColor,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.authBodyTextColor,
                    ),
                  ],
                ),
              ),
            ),

            /// Expanded items
            if (isExpanded && items.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  children: List.generate(items.length, (i) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: _buildItemRow(i + 1, items[i]),
                        ),
                        if (i < items.length - 1)
                          Divider(
                            color: const Color(0xFFEFEFEF),
                            thickness: 1,
                            height: 1,
                          ),
                      ],
                    );
                  }),
                ),
              ),

            Divider(color: const Color(0xFFEFEFEF), thickness: 1, height: 1),
          ],
        );
      },
    );
  }

  // ── Shared item row ────────────────────────────────────────────────────────

  Widget _buildItemRow(int number, OrderItems item) {
    final imageUrl = _resolveImageUrl(item.productImage ?? '');
    return Row(
      children: [
        SizedBox(
          width: 24.w,
          child: Text(
            '$number.',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.authBodyTextColor,
            ),
          ),
        ),

        SizedBox(width: 6.w),

        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  height: 40.h,
                  width: 40.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 40.h,
                      width: 40.h,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (c, o, s) => SizedBox(
                    height: 40.h,
                    width: 40.h,
                    child: const Icon(Icons.image_not_supported, size: 20),
                  ),
                )
              : SizedBox(
                  height: 40.h,
                  width: 40.h,
                  child: const Icon(Icons.image_not_supported, size: 20),
                ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Text(
            item.productName ?? '',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        Text(
          '${(item.quantity ?? 0).toString().padLeft(2, '0')} Pcs',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _emptyState() {
    return Center(
      child: Text(
        'No orders for $selectedPeriod',
        style: TextStyle(fontSize: 14.sp, color: AppColors.authBodyTextColor),
      ),
    );
  }
}
