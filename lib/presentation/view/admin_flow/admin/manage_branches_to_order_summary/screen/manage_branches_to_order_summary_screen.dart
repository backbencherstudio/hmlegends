import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
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

  @override
  void initState() {
    super.initState();

    debugPrint("Received Manager ID: ${widget.managerId}");

    Future.microtask(() {
      final provider =
      // ignore: use_build_context_synchronously
      Provider.of<ManageBranchProvider>(context, listen: false);
      provider.getSingleBranch(widget.managerId ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final managerBranchProvider = Provider.of<ManageBranchProvider>(context);
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );

    final profile = profileProvider.adminInfoModel?.data;
    final notification = notificationProvider.adminNotificationModel?.data;

    final singleBranch = managerBranchProvider.singleBranchModel?.data;
    final singleBranchOrders = singleBranch?.orders ?? [];
    final singleBranchOrdersItems = singleBranchOrders.isNotEmpty
        ? (singleBranchOrders.first.orderItems ?? [])
        : [];

    final avatar = singleBranch?.avatar ?? '';
    final String fullAvatarUrl;
    if (avatar.startsWith('http')) {
      fullAvatarUrl = avatar;
    } else if (avatar.isNotEmpty) {
      if (avatar.startsWith('/')) {
        fullAvatarUrl = "${ApiEndpoints.baseUrl}$avatar";
      } else {
        fullAvatarUrl = "${ApiEndpoints.baseUrl}/storage/avatar/$avatar";
      }
    } else {
      fullAvatarUrl = '';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),

      appBar: CustomAppBarTwo(
        title: "Order Summary",
        profileImage: profile?.avatar ?? '',
        notificationCount: notification?.length ?? 0,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),

      body:
          managerBranchProvider.isLoading
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
                          /// Branch Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: fullAvatarUrl.isNotEmpty
                                ? Image.network(
                                    fullAvatarUrl,
                                    height: 65.h,
                                    width: 65.h,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return SizedBox(
                                        height: 65.h,
                                        width: 65.h,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
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

                          /// Branch Info
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
                                    Image.asset(
                                      AssetPaths.locationIcon,
                                      height: 20.h,
                                    ),

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

                          /// Status
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
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

                    /// Total Orders Header
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
                              Text(selectedPeriod),
                              const Icon(Icons.keyboard_arrow_down_rounded),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Divider(
                      color: const Color(0xFFEFEFEF),
                      thickness: 1,
                      height: 16.h,
                    ),

                    SizedBox(height: 14.h),

                    /// Order Items
                    Expanded(
                      child: ListView.separated(
                        itemCount: singleBranchOrdersItems.length,
                        separatorBuilder:
                            (_, __) => Divider(
                              color: const Color(0xFFEFEFEF),
                              thickness: 1,
                              height: 16.h,
                            ),
                        itemBuilder: (context, index) {
                          final item = singleBranchOrdersItems[index];
                          final productImage = item.productImage ?? '';
                          final String fullProductImageUrl;
                          if (productImage.startsWith('http')) {
                            fullProductImageUrl = productImage;
                          } else if (productImage.isNotEmpty) {
                            if (productImage.startsWith('/')) {
                              fullProductImageUrl = "${ApiEndpoints.baseUrl}$productImage";
                            } else {
                              fullProductImageUrl = "${ApiEndpoints.baseUrl}/$productImage";
                            }
                          } else {
                            fullProductImageUrl = '';
                          }

                          return Row(
                            children: [
                              Text(
                                "${index + 1}.",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.authBodyTextColor,
                                ),
                              ),

                              SizedBox(width: 8.w),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: fullProductImageUrl.isNotEmpty
                                    ? Image.network(
                                        fullProductImageUrl,
                                        height: 40.h,
                                        width: 40.h,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return SizedBox(
                                            height: 40.h,
                                            width: 40.h,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (c, o, s) => SizedBox(
                                          height: 40.h,
                                          width: 40.h,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 40.h,
                                        width: 40.h,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 20,
                                        ),
                                      ),
                              ),

                              SizedBox(width: 10.w),

                              Expanded(
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              Text(
                                "${item.quantity.toString().padLeft(2, '0')} pcs",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
    );
  }
}
