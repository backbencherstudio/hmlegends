import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/drivier_flow/driver_bottom_nav/viewmodel/driver_bottom_nav_provider.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/presentation/view/drivier_flow/driver_home/viewmodel/driver_branch_detail_viewmodel.dart';
import 'package:hmlegends/presentation/view/drivier_flow/driver_home/viewmodel/driver_notification_provider.dart';
import 'package:intl/intl.dart';

class DriverDeliverySummaryScreen extends StatefulWidget {
  const DriverDeliverySummaryScreen({super.key});

  @override
  State<DriverDeliverySummaryScreen> createState() =>
      _DriverDeliverySummaryScreenState();
}

class _DriverDeliverySummaryScreenState
    extends State<DriverDeliverySummaryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final deliveryId = args?["deliveryId"];
      if (deliveryId != null) {
        Provider.of<DriverBranchDetailViewModel>(
          context,
          listen: false,
        ).fetchSingleDelivery(deliveryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = args?["name"] ?? "Branch Name-01";
    final productsCount = args?["products"] ?? "0";

    return Consumer<DriverBranchDetailViewModel>(
      builder: (context, vm, child) {
        final data = vm.deliveryModel?.data;
        final orderItems = data?.order?.orderItems ?? [];

        String completedTime = "--:--";
        if (data?.deliveredAt != null) {
          try {
            final dt = DateTime.parse(data!.deliveredAt!).toLocal();
            completedTime = DateFormat('hh:mm a, MMM dd, yyyy').format(dt);
          } catch (e) {
            completedTime = data!.deliveredAt!;
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFFF6F7), // Light pinkish background
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(64.h),
            child: Consumer<DriverNotificationProvider>(
              builder: (context, provider, child) {
                return CustomAppBarTwo(
                  title: "Delivery Summary",
                  notificationCount: provider.unreadCount,
                  colorMain: const Color(0xFFFFF6F7),
                  colorSpace: Colors.transparent,
                  onNotificationTap: () async {
                    await provider.getDriverNotification();
                    if (context.mounted) {
                      Navigator.pushNamed(context, RouteNames.adminNotificationScreen);
                    }
                  },
                  onBackTap: () {
              final bottomNavProvider = Provider.of<DriverBottomNavProvider>(
                context,
                listen: false,
              );
              bottomNavProvider.updateIndex(0);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.driverBottomNavScreen,
                    (route) => false,
                  );
                },
                );
              },
            ),
          ),
          body:
              vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        // Header Card
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Text(
                                    "Total Products:   ",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    productsCount,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: const Color(0xFFED5E68),
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Completed at:   ",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    completedTime,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Items Delivered Header
                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: const Color(0xFFED5E68),
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Items Delivered",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Divider(color: Colors.grey.shade300, thickness: 1),

                        // Products List
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
                            itemCount: orderItems.length,
                            separatorBuilder:
                                (context, index) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final item = orderItems[index];
                              final productName =
                                  item.product?.name ?? "Unknown Product";
                              final quantity = item.quantity?.toString() ?? "0";
                              return Row(
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(
                                        color: const Color(0xFFED5E68),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: const Color(0xFFED5E68),
                                      size: 14.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      productName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "($quantity)",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
