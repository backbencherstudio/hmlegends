import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/invoice/view_model/admin_invoice_provider.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/route/route_names.dart';
import '../../../view_model/order/order_screen_provider.dart';

class OrderSummaryMakeInvoiceScreen extends StatelessWidget {
  const OrderSummaryMakeInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderScreenProvider>(context);
    final invoiceProvider = context.watch<AdminInvoiceProvider>();
    final invoiceData = invoiceProvider.allInvoiceModel?.data?.invoices;

    /// ------------------- Check if adminSingleOrderModel exists --------------
    if (provider.adminSingleOrderModel == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF5F5),
        appBar: CustomAppBarTwo(
          title: 'Order Summary',
          notificationCount: 4,
          profileImage: AssetPaths.personIcon,
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
          notificationCount: 4,
          profileImage: AssetPaths.personIcon,
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
    final orderStatus = orders.status ?? 'Unknown Status';

    /// ---------------- Get order items list for ListView.builder -------------
    final orderItems = orders.orderItems ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: 'Order Summary',
        notificationCount: 4,
        profileImage: AssetPaths.personIcon,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),

      ///----------------- Add header to display order summary info ------------
      body: Column(
        children: [
          SizedBox(height: 24.h),

          /// ------------------ Branch Name / Total Units / Status ------------
          Expanded(
            child:
                orderItems.isEmpty
                    ? const Center(child: Text('No items in this order'))
                    : ListView.builder(
                      itemCount: orderItems.length,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              children: [
                                /// ------------ User Name ---------------------
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD1E4C9),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.r),
                                        bottomLeft: Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        userName,
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

                                ///------------ Quantity -----------------------
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

                                /// ------------ Status ------------------------
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    color: const Color(0xFF5BB450),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        orderStatus,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
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
                    ),
          ),

          /// --------------- Order Summary Header -----------------------------
          Expanded(
            flex: 1,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: orderItems.length,
              separatorBuilder: (context, index) {
                return Divider(
                  color: const Color(0xFFD2D2D5),
                  thickness: 1,
                  height: 16.h,
                );
              },
              itemBuilder: (context, itemIndex) {
                final item = orderItems[itemIndex];
                return Row(
                  children: [
                    Text(
                      "${itemIndex + 1}.",
                      style: TextStyle(
                        color: AppColors.authBodyTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        item.product!.image!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      "${(orderItems[itemIndex].quantity ?? 0).toString().padLeft(2, '0')} pcs",
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

          /// ----------------- Order Total Items ------------------------------
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "  PCS",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ------------- Make Invoice Button --------------------------------
          Text(
            textAlign: TextAlign.center,
            "You approved Branch Name's order. Now you can make an invoice.",
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFF777980),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          AuthButton(
            text: Text(
              "Make Invoice",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () async {
              /// how to add invoice id
              final invoiceId = invoiceData?.first.orderId ?? '';
              await invoiceProvider.fetchInvoiceDetail(invoiceId);
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, RouteNames.adminInvoiceDetailScreen);
            },
            color: Color(0xFFE20613),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
