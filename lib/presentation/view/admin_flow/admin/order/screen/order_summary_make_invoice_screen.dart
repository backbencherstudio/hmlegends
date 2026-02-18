import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';

import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:provider/provider.dart';

import '../../../view_model/order/order_screen_provider.dart';

class OrderSummaryMakeInvoiceScreen extends StatelessWidget {
  const OrderSummaryMakeInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderScreenProvider>(context);
    final userName = provider.adminSingleOrderModel!.order?.user?.name ?? [];
    final orderTotalItems =
        provider.adminSingleOrderModel!.order?.totalQuantity ?? [];
    final orderStatus = provider.adminSingleOrderModel!.order?.status ?? [];

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
      body: ListView.builder(
        itemCount: orders.length,
        padding: EdgeInsets.only(bottom: 8.h),
        itemBuilder: (context, index) {
          final item = orders[index];

          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
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
                          "${index + 1}.  ${item.user?.name ?? ""}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.authBodyTextColor,
                          ),
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
                          "Total Units: ${item.totalQuantity ?? 'Unknown'}",
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
                        color: const Color(0xFFE20614),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await provider.adminSingleOrder(item.id ?? "");
                          if (mounted) {
                            navigator.pushNamed(
                              RouteNames.orderSummaryViewScreen,
                              arguments: item.id ?? "",
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.r),
                              bottomRight: Radius.circular(8.r),
                            ),
                          ),
                        ),
                        child: Text(
                          "View",
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
          );
        },
      ),
    );
  }
}
