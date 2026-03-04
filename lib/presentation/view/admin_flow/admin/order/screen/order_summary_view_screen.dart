import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:provider/provider.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/order/order_screen_provider.dart';

class OrderSummaryViewScreen extends StatelessWidget {
  const OrderSummaryViewScreen({super.key});

  Future<void> _showDialog(
    BuildContext context,
    String? title,
    Widget? child,
    String? noText,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            textAlign: TextAlign.center,
            title ?? "Are you sure?",
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFF1D1F2C),
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(0xFFE20613)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: child,
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(0xFF777980)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                noText ?? "No",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderScreenProvider>(context);
    final singleOrder = provider.adminSingleOrderModel?.order?.orderItems ?? [];
    final orderId = provider.adminSingleOrderModel?.order?.id ?? "";
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    final notificationData = notificationProvider.adminNotificationModel?.data;



    // Calculate total items
    final totalItems = singleOrder.fold<int>(
      0,
      (sum, item) => sum + (item.quantity ?? 0),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Order Summary",
        profileImage: data?.avatar ?? AssetPaths.personIcon,
        notificationCount: notificationData?.length ?? 0,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// ------------------ User Name ----------------------
                  Text(
                    provider.adminSingleOrderModel?.order?.user?.name ??
                        "Branch Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),

                  /// ------------------ Approve Button ----------------------
                  InkWell(
                    onTap: () {
                      _showDialog(
                        context,
                        "Are you sure you want to approve today's order?",
                        InkWell(
                          onTap: () async {
                            await provider.approveOrder(orderId);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                Navigator.pop(context);
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Container(
                                    width: 335.w,
                                    height: 451.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AssetPaths.successfulIcon,
                                          height: 100.h,
                                          width: 100.w,
                                        ),
                                        SizedBox(height: 30.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                          ),
                                          child: Text(
                                            "You have successfully approved the order.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
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
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        "No",
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE20613),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// ------------------ Order Items List ----------------------
            Expanded(
              child: ListView.builder(
                itemCount: singleOrder.length,
                itemBuilder: (context, index) {
                  // if (index == singleOrder.length) {
                  //   return Padding(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 5.w,
                  //       vertical: 18.h,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           "Total Items:",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.w700,
                  //             fontSize: 15.sp,
                  //           ),
                  //         ),
                  //
                  //         RichText(
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 text: "$totalItems",
                  //                 style: TextStyle(color: Colors.black),
                  //               ),
                  //               TextSpan(
                  //                 text: "  PCS",
                  //                 style: TextStyle(color: Colors.grey),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }

                  // ---------------- Item Row ----------------
                  final data = singleOrder[index];

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        /// ------------------ Index Number ----------------------
                        Text(
                          "${index + 1}.",
                          style: TextStyle(
                            color: AppColors.authBodyTextColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        ///----------------  Product Name ----------------------
                        Expanded(
                          child: Text(
                             "N/A",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        ///-------------- Quantity ----------------------
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(color: Colors.black),
                                text: "",
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
