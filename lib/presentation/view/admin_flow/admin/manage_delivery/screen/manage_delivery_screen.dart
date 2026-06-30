import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_delivery/view_model/delivery_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';

import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/notification_admin/admin_notification_provider.dart';
import '../widget/assign_driver_sheet.dart';
import '../widget/branch_card.dart';

class ManageDeliveryScreen extends StatefulWidget {
  const ManageDeliveryScreen({super.key});

  @override
  State<ManageDeliveryScreen> createState() => _ManageDeliveryScreenState();
}

class _ManageDeliveryScreenState extends State<ManageDeliveryScreen> {
  @override
  void initState() {
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<DeliveryProvider>(context, listen: false).getAllDeliveries();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final adminNotificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBarTwo(
        title: 'Manage Delivery',
        profileImage: '${data?.avatar}',
        notificationCount: adminNotificationProvider.unreadCount,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        onBackTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<DeliveryProvider>().getAllDeliveries();
          },
          child: Consumer<DeliveryProvider>(
            builder: (context, provider, _) {
              // Show loading indicator while data is being fetched
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Check if data is null or empty
              if (provider.allDeliveriesModel?.data == null ||
                  provider.allDeliveriesModel!.data!.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 150.h),
                    const Center(child: Text('No deliveries available')),
                  ],
                );
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: provider.allDeliveriesModel!.data!.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  var branch = provider.allDeliveriesModel!.data![index];

                  final status = (branch.status ?? '').toString().toUpperCase();
                  final isProcessing = status == "PROCESSING";
                  final isApproved = status == 'APPROVED';
                  final isPending = status == 'PENDING';
                  final isShipped = status == 'SHIPPED';
                  final isDelivered = status == 'DELIVERED';
                  final isCancelled = status == 'CANCELLED';
                  final isCompleted = status == 'COMPLETED';

                  // Determine button color and label based on status
                  Color buttonColor;
                  String buttonText;

                  if (isApproved) {
                    buttonColor = Colors.red;
                    buttonText = 'Assign to Driver';
                  } else if (isPending) {
                    buttonColor = Colors.grey;
                    buttonText = 'Pending';
                  } else if (isShipped) {
                    buttonColor = Colors.grey;
                    buttonText = 'Shipped';
                  } else if (isDelivered) {
                    buttonColor = Colors.grey;
                    buttonText = 'Delivered';
                  } else if (isCancelled) {
                    buttonColor = Colors.grey;
                    buttonText = 'Cancelled';
                  } else if (isCompleted) {
                    buttonColor = Colors.grey;
                    buttonText = 'Completed';
                  } else if (isProcessing) {
                    buttonColor = Colors.grey;
                    buttonText = 'Processing';
                  } else {
                    buttonColor = Colors.grey;
                    buttonText = 'Assign to Driver';
                  }

                  log("======== status : ${branch.status}");
                  return BranchCard(
                    name: branch.user?.name ?? "N/A",
                    totalProducts: branch.totalQuantity ?? 0,
                    address: branch.user?.address ?? "N/A",
                    backgroundColor: WidgetStateProperty.all<Color>(
                      buttonColor,
                    ),
                    text: buttonText,
                    isLoading: provider.assigningOrderId == branch.id,

                    onAssignTap: isApproved
                        ? () async {
                            /// ------------ Open bottom sheet ---------------
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r),
                                ),
                              ),
                              builder:
                                  (_) => AssignDriverSheet(deliveryId: branch.id),
                            );
                            log(branch.id ?? '');
                          }
                        : null,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
