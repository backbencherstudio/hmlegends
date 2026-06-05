import 'package:flutter/material.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/order/screen/order_summary_make_invoice_screen.dart';
import 'package:hmlegends/presentation/view/driver_flow/profile_driver/change_info_driver.dart';
import '../../presentation/view/admin_flow/admin/bottom_nav/screen/wrapper.dart';
import '../../presentation/view/admin_flow/admin/home/screen/head_office_home_screen.dart';
import '../../presentation/view/admin_flow/admin/home/screen/pending_user_list.dart';
import '../../presentation/view/admin_flow/admin/invoice/screen/admin_invoice_detail_screen.dart';
import '../../presentation/view/admin_flow/admin/invoice/screen/head_office_invoice_screen.dart';
import '../../presentation/view/admin_flow/admin/invoice_status/screen/invoice_status_screen.dart';
import '../../presentation/view/admin_flow/admin/manage_branches/screen/add_new_branches_screen.dart';
import '../../presentation/view/admin_flow/admin/manage_branches/screen/edit_branch_screen.dart';
import '../../presentation/view/admin_flow/admin/manage_branches/screen/manage_branches_screen.dart';
import '../../presentation/view/admin_flow/admin/manage_branches_to_order_summary/screen/manage_branches_to_order_summary_screen.dart';
import '../../presentation/view/admin_flow/admin/manage_delivery/screen/manage_delivery_screen.dart';
import '../../presentation/view/admin_flow/admin/notification_admin/admin_notification_screen.dart';
import '../../presentation/view/admin_flow/admin/order/screen/order_summary_screen.dart';
import '../../presentation/view/admin_flow/admin/order/screen/order_summary_view_screen.dart';
import '../../presentation/view/admin_flow/admin/order/screen/order_summary_view_successful_screen.dart';
import '../../presentation/view/admin_flow/admin/profile/screen/head_office_change_info_change.dart';
import '../../presentation/view/admin_flow/admin/profile/screen/head_office_change_password_screen.dart';
import '../../presentation/view/admin_flow/admin/profile/screen/head_office_profile_screen.dart';
import '../../presentation/view/admin_flow/admin/stock/screen/edit_stock_screen.dart';
import '../../presentation/view/admin_flow/admin_model/admin_product_model.dart';
import '../../presentation/view/auth/forget_password/screen/forget_password_screen.dart';
import '../../presentation/view/auth/login/screen/login_screen.dart';
import '../../presentation/view/auth/otp_verify/screen/otp_verify_screen.dart';
import '../../presentation/view/auth/set_new_password/screen/set_new_password_screen.dart';
import '../../presentation/view/auth/signup/screen/signup_screen.dart';
import '../../presentation/view/branch_manager_flow/Invoice/presentation/invoice_screen.dart';
import '../../presentation/view/branch_manager_flow/Invoice/presentation/screens/view_details.dart';
import '../../presentation/view/branch_manager_flow/home/home_screen.dart';
import '../../presentation/view/branch_manager_flow/orders/presentation/view/orders_screen.dart';
import '../../presentation/view/branch_manager_flow/orders/presentation/view/screens/my_orders.dart';
import '../../presentation/view/branch_manager_flow/parent/bottom_nav_bar.dart';
import '../../presentation/view/branch_manager_flow/parent/parent_screen.dart';
import '../../presentation/view/branch_manager_flow/profile/profile_screen.dart';
import '../../presentation/view/branch_manager_flow/profile/screens/change_info.dart';
import '../../presentation/view/branch_manager_flow/profile/screens/change_password.dart';
import '../../presentation/view/driver_flow/driver_brance_detailScreen/confirm_delivery_screen.dart';
import '../../presentation/view/driver_flow/driver_brance_detailScreen/delivery_summery_screen.dart';
import '../../presentation/view/driver_flow/driver_brance_detailScreen/driver_brance_detail_screen.dart';
import '../../presentation/view/driver_flow/driver_screen.dart';
import '../../presentation/view/driver_flow/parent/parent_screen.dart';
import '../../presentation/view/driver_flow/tracking/tracking_screen.dart';
import '../../presentation/view/onboarding/view/onboarding_screen.dart';
import '../../presentation/view/splash/view/splash_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    RouteNames.splashScreen: (context) => const SplashScreen(),
    RouteNames.onboardingScreen: (context) => const OnboardingScreen(),
    RouteNames.signUpScreen: (context) => SignUpScreen(),
    RouteNames.loginScreen: (context) => LoginScreen(),
    RouteNames.forgetPasswordScreen: (context) => ForgetPasswordScreen(),
    RouteNames.otpVerifyScreen: (context) => OtpVerifyScreen(),
    RouteNames.setNewPasswordScreen: (context) => SetNewPasswordScreen(),
    RouteNames.mainWrapper: (context) => MainWrapper(),
    RouteNames.branchHomeScreen: (context) => BranchHomeScreen(),
    RouteNames.branchParentScreen: (context) => BranchParentScreen(),
    RouteNames.bottomNavBar: (context) => BottomNavBar(),
    RouteNames.ordersScreen: (context) => OrdersScreen(),
    RouteNames.myOrders: (context) => MyOrders(),
    RouteNames.invoiceScreen: (context) => InvoiceScreen(),
    RouteNames.viewDetails: (context) => ViewDetails(),
    RouteNames.profileScreen: (context) => ProfileScreen(),
    RouteNames.changePassword: (context) => ChangePassword(),
    RouteNames.changeInfo: (context) => ChangeInfo(),
    RouteNames.notificationScreen: (context) => const AdminNotificationScreen(),
    RouteNames.driverScreen: (context) => DriverScreen(),
    RouteNames.driverBottomNavBar: (context) => DriverBottomNavBar(),
    RouteNames.driverBranchParentScreen:
        (context) => DriverBranchParentScreen(),
    RouteNames.editStockScreen: (context) {
      final product = ModalRoute.of(context)!.settings.arguments as Data;
      return EditStockScreen(product: product);
    },
    RouteNames.driverBranseDetailScreen:
        (context) => DriverBranchDetailScreen(),
    RouteNames.orderSummaryScreen:
        (context) => OrderSummaryScreen(fromBottomNav: false),
    RouteNames.orderSummaryViewScreen: (context) => OrderSummaryViewScreen(),
    RouteNames.confirmDeliveryScreen: (context) => ConfirmDeliveryScreen(),
    RouteNames.deliverySummeryScreen: (context) => DeliverySummeryScreen(),
    RouteNames.orderSummaryMakeInvoiceScreen:
        (context) => OrderSummaryMakeInvoiceScreen(),
    RouteNames.orderSummaryViewSuccessfulScreen:
        (context) => OrderSummaryViewSuccessfulScreen(),
    RouteNames.headOfficeInvoiceScreen:
        (context) => HeadOfficeInvoiceScreen(fromBottomNav: false),
    RouteNames.manageBranchesScreen: (context) => ManageBranchesScreen(),
    RouteNames.addNewBranchesScreen: (context) => AddNewBranchesScreen(),
    RouteNames.invoiceStatusScreen: (context) => InvoiceStatusScreen(),
    RouteNames.adminInvoiceDetailScreen:
        (context) => AdminInvoiceDetailScreen(),
    RouteNames.headOfficeHomeScreen: ((context) => HeadOfficeHomeScreen()),

    RouteNames.headOfficeProfileScreen: (context) => HeadOfficeProfileScreen(),
    RouteNames.headOfficeChangePasswordScreen:
        (context) => HeadOfficeChangePasswordScreen(),
    RouteNames.headOfficeChangeInfoScreen:
        (context) => HeadOfficeChangeInfoScreen(),
    RouteNames.manageDeliveryScreen: (context) => ManageDeliveryScreen(),
    RouteNames.manageBranchesToOrderSummaryScreen: (context) {
      final managerId = ModalRoute.of(context)!.settings.arguments as String;

      return ManageBranchesToOrderSummaryScreen(managerId: managerId);
    },
    RouteNames.editBranchScreen: (context) {
      final managerId = ModalRoute.of(context)!.settings.arguments as String;

      return EditBranchScreen(managerId: managerId);
    },
    RouteNames.changeInfoDriver: (context) => ChangeInfoDriver(),
    RouteNames.adminNotificationScreen: (context) => AdminNotificationScreen(),
    RouteNames.pendingUserList: (context) => PendingUserList(),
    RouteNames.trackingScreen: (context) => TrackingScreen(),
  };
}
