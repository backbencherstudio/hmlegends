import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/invoice/view_model/admin_invoice_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:hmlegends/presentation/widget/custom_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import '../../../../../../core/route/route_names.dart';
import '../../../view_model/order/order_screen_provider.dart';

class OrderSummaryMakeInvoiceScreen extends StatelessWidget {
  const OrderSummaryMakeInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderScreenProvider>(context);
    final invoiceProvider = context.watch<AdminInvoiceProvider>();
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(context);

    /// ------------------- Check if adminSingleOrderModel exists --------------
    if (provider.adminSingleOrderModel == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF5F5),
        appBar: CustomAppBarTwo(
          title: 'Order Summary',
          notificationCount: notificationProvider.unreadCount,
          profileImage: data?.avatar,
          colorMain: const Color(0xFFFFF5F5),
          colorSpace: const Color(0xFFFFF5F5),
          onBackTap: () => Navigator.pop(context),
        ),
        body: const Center(child: Text('No orders found')),
      );
    }

    final orders = provider.adminSingleOrderModel!.order;

    /// ------------------ Handle case when orders is null ---------------------
    if (orders == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF5F5),
        appBar: CustomAppBarTwo(
          title: 'Order Summary',
          notificationCount: notificationProvider.unreadCount,
          profileImage: data?.avatar,
          colorMain: const Color(0xFFFFF5F5),
          colorSpace: const Color(0xFFFFF5F5),
          onBackTap: () => Navigator.pop(context),
        ),
        body: const Center(child: Text('Order details not available')),
      );
    }

    /// ---------------- These are single values, not lists --------------------
    final userName = orders.user?.name ?? 'Unknown User';
    final orderTotalItems = orders.totalQuantity ?? 0;

    /// ---------------- Get order items list for ListView.builder -------------
    final orderItems = orders.orderItems ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: 'Order Summary',
        notificationCount: notificationProvider.unreadCount,
        profileImage: data?.avatar,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          SizedBox(height: 24.h),

          /// ------------------ Branch Name / Total Units / Status ------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          bottomLeft: Radius.circular(8.r),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "1.  $userName",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.authBodyTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: const Color(0xFFE6ECDE),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Total Units: $orderTotalItems",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.authBodyTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF5BB450),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Approved",
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

          SizedBox(height: 16.h),

          /// --------------- Order Items List -----------------------------
          Expanded(
            child: orderItems.isEmpty
                ? const Center(child: Text('No items in this order'))
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: orderItems.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black12,
                      thickness: 0.8,
                      height: 16.h,
                    ),
                    itemBuilder: (context, index) {
                      final item = orderItems[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Text(
                              "${index + 1}.",
                              style: TextStyle(
                                color: AppColors.authBodyTextColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            CustomNetworkImage(
                              imageUrl: item.product?.image ?? "",
                              height: 32.h,
                              width: 50.w,
                              borderRadius: 6.r,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                item.product?.name ?? "Unknown Product",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Text(
                              "${(item.quantity ?? 0).toString().padLeft(2, '0')} pcs",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          /// ----------------- Order Total Items ------------------------------
          const Divider(color: Colors.black12, thickness: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Items:",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$orderTotalItems".toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      TextSpan(
                        text: " pcs",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black12, thickness: 1),

          /// ------------- Make Invoice Button Description --------------------
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              "You approved $userName's order. Now you\ncan make invoice.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFF777980),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 20.h),

          /// ------------- Make Invoice Button --------------------------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE20613),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  elevation: 0,
                ),
                onPressed: invoiceProvider.isLoading
                    ? null
                    : () async {
                        final navigator = Navigator.of(context);
                        final res = await invoiceProvider.createInvoice(orders.id ?? "");
                        if (!res.success) {
                          Utils.showToast(
                            msg: res.message,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        } else {
                          Utils.showToast(
                            msg: "Invoice generated successfully",
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                        }
                        await invoiceProvider.fetchInvoiceDetail(orders.id ?? "");
                        navigator.pushNamed(RouteNames.adminInvoiceDetailScreen);
                      },
                child: invoiceProvider.isLoading
                    ? const SpinKitSpinningLines(
                        color: Colors.white,
                        size: 24,
                      )
                    : Text(
                        "Make Invoice",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
