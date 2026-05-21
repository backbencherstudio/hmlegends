import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/home/home_screen_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../view_model/notification_admin/admin_notification_provider.dart';
import '../widget/info_card.dart';
import '../widget/weekly_bar_chart.dart';

class HeadOfficeHomeScreen extends StatelessWidget {
  const HeadOfficeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreenProvider = Provider.of<HomeScreenProvider>(context);
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final adminNotificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    final notification = adminNotificationProvider.adminNotificationModel?.data;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        profileImage: data?.avatar,
        notificationCount: notification?.length ?? 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),

            //_stockCard(context),
            SizedBox(height: 16.h),
            _gridCards(context, homeScreenProvider),

            SizedBox(height: 16.h),
            Text(
              'Items Ordered (Last 7 Days)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: AppColors.authHeaderTextColor,
              ),
            ),
            SizedBox(height: 12.h),
            const WeeklyBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _gridCards(BuildContext context, HomeScreenProvider provider) {
    final data = provider.invoiceStatusModel?.data;

    final totalInvoice = data?.invoice?.totalInvoice ?? 0;
    final paidInvoice = data?.invoice?.paidInvoice ?? 0;

    final activeBranch = data?.branch?.activeBranch ?? 0;
    final lockedBranch = data?.branch?.lockedBranch ?? 0;

    final totalOrder = data?.order?.totalOrder ?? 0;
    final completedOrder = data?.order?.totalCompletedOrder ?? 0;

    final toDaysDelivery = data?.delivery?.todaysDelivery ?? 0;
    final assignedDelivery = data?.delivery?.assignedDelivery ?? 0;

    return GridView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return InfoCard(
              onTaps:
                  () => Navigator.pushNamed(
                    context,
                    RouteNames.invoiceStatusScreen,
                  ),
              title: 'Invoices',
              subtitle: 'Status',
              label1: 'Paid Invoices',
              value1: "$paidInvoice/$totalInvoice",
              iconPath: AssetPaths.invoiceIcon,
            );

          case 1:
            return InfoCard(
              onTaps:
                  () => Navigator.pushNamed(
                    context,
                    RouteNames.manageBranchesScreen,
                  ),
              title: 'Manage',
              subtitle: 'Branches',
              label1: 'Active',
              value1: "$activeBranch",
              label2: 'Locked',
              value2: "$lockedBranch",
              iconPath: AssetPaths.branchIcon,
            );

          case 2:
            return InfoCard(
              onTaps:
                  () => Navigator.pushNamed(
                    context,
                    RouteNames.orderSummaryScreen,
                  ),
              title: 'Orders',
              subtitle: 'Summary',
              label1: 'Completed Orders',
              value1: "$completedOrder/$totalOrder",
              iconPath: AssetPaths.orderIcon,
            );
          case 3:
            return InfoCard(
              onTaps:
                  () => Navigator.pushNamed(
                    context,
                    RouteNames.manageDeliveryScreen,
                  ),
              title: 'Manage',
              subtitle: 'Delivery',
              label1: "Today's Delivery",
              value1: "$toDaysDelivery",
              label2: 'Assigned Delivery',
              value2: "$assignedDelivery",
              iconPath: AssetPaths.deliveryIcon,
            );

          default:
            return Consumer<HomeScreenProvider>(
              builder: (context, provider, child) {
                return InfoCard(
                  onTaps: () async {
                    await provider.getPendingUser();
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, RouteNames.pendingUserList);
                  },

                  title: 'User',
                  subtitle: 'Approval',
                  label1: "Pending User",
                  value1: "${provider.pendingUserModel?.data?.total}",
                  label2: 'See All Pending',
                  value2: "",
                  iconPath: "assets/icons/person.png",
                );
              },
            );
        }
      },
    );
  }
}
