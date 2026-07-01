import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/delivery_progress/viewmodel/delivery_progress_viewmodel.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/delivery_progress/data/delivery_progress_model.dart';

class DeliveryProgressScreen extends StatefulWidget {
  final String? orderId;

  const DeliveryProgressScreen({super.key, this.orderId});

  @override
  State<DeliveryProgressScreen> createState() => _DeliveryProgressScreenState();
}

class _DeliveryProgressScreenState extends State<DeliveryProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final progressVm = Provider.of<DeliveryProgressViewModel>(
        context,
        listen: false,
      );
      progressVm.fetchDeliveryProgress();
    });
  }

  IconData _getIconForStep(String key) {
    switch (key) {
      case 'order_placed':
        return Icons.receipt_long_outlined;
      case 'processing':
        return Icons.local_shipping_outlined;
      case 'shift_to_driver':
        return Icons.person_outline;
      case 'driver_received':
        return Icons.hail_outlined;
      case 'on_the_way':
        return Icons.alt_route_outlined;
      case 'arrived':
        return Icons.location_on_outlined;
      case 'delivered':
        return Icons.home_work_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _getSubtitleTagForStep(String key, Destination? dest) {
    switch (key) {
      case 'order_placed':
        return '(Order Placed)';
      case 'processing':
        return '(Head office)';
      case 'shift_to_driver':
        return '(Leave head office)';
      case 'driver_received':
        return '(Driver Received)';
      case 'arrived':
        return '(Arrived)';
      case 'delivered':
        return '(${dest?.branchName ?? 'Branch office'})';
      default:
        return '';
    }
  }

  String _getAddressForStep(String key, Destination? dest) {
    switch (key) {
      case 'order_placed':
      case 'processing':
      case 'shift_to_driver':
      case 'driver_received':
        return '';
      case 'on_the_way':
        return '';
      default:
        return dest?.address ?? '';
    }
  }

  String _formatTimestamp(String? timestampStr) {
    if (timestampStr == null || timestampStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(timestampStr).toLocal();
      return DateFormat('HH:mm:ss').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final profileData = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBarTwo(
        title: 'My Delivery',
        profileImage: profileData?.avatar,
        notificationCount: notificationProvider.unreadCount,
        colorMain: Colors.white,
        colorSpace: AppColors.bgColor,
        onProfileTap: () {
          context.read<BottomNavViewModel>().updateIndex(3);
          Navigator.pop(context);
        },
      ),
      body: Consumer<DeliveryProgressViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
              ),
            );
          }

          if (vm.error != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.outOfStockTextColor,
                      size: 48.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      vm.error!,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final data = vm.deliveryProgress;
          if (data == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.authHeaderTextColor,
                      size: 48.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "No delivery progress details found.",
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final progressList = data.progress ?? [];

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View Delivery Progress',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: progressList.length,
                    itemBuilder: (context, index) {
                      final step = progressList[index];
                      final isCompleted = step.completed ?? false;
                      final isLast = index == progressList.length - 1;

                      // Check if it is the current active step (first uncompleted step)
                      bool isNext = false;
                      if (!isCompleted && index > 0) {
                        final previousStep = progressList[index - 1];
                        if (previousStep.completed ?? false) {
                          isNext = true;
                        }
                      } else if (!isCompleted && index == 0) {
                        isNext = true;
                      }

                      final circleColor =
                          isCompleted ? AppColors.primaryColor : Colors.white;
                      final borderColor =
                          isCompleted
                              ? AppColors.primaryColor
                              : (isNext
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300);
                      final iconColor =
                          isCompleted
                              ? Colors.white
                              : (isNext
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade400);

                      final title = step.label ?? '';
                      final subtitle = _getSubtitleTagForStep(
                        step.key ?? '',
                        data.destination,
                      );
                      final address = _getAddressForStep(
                        step.key ?? '',
                        data.destination,
                      );
                      final time = _formatTimestamp(step.timestamp);

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  color: circleColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: borderColor,
                                    width: 2.w,
                                  ),
                                ),
                                child: Icon(
                                  _getIconForStep(step.key ?? ''),
                                  color: iconColor,
                                  size: 22.sp,
                                ),
                              ),
                              if (!isLast)
                                Container(
                                  width: 2.w,
                                  height: 52.h,
                                  color:
                                      isCompleted
                                          ? AppColors.primaryColor
                                          : Colors.grey.shade300,
                                ),
                            ],
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: title,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    isCompleted || isNext
                                                        ? Colors.black87
                                                        : Colors.grey.shade500,
                                              ),
                                            ),
                                            if (subtitle.isNotEmpty) ...[
                                              const TextSpan(text: '  '),
                                              TextSpan(
                                                text: subtitle,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  address,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (time.isNotEmpty) ...[
                            SizedBox(width: 8.w),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ],
                      );
                    },
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
