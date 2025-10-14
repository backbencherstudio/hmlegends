import 'package:flutter/material.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../presentation/view/admin_flow/admin/bottom_nav/screen/wrapper.dart';
import '../../presentation/view/admin_flow/admin/invoice/screen/head_office_invoice_screen.dart';
import '../../presentation/view/admin_flow/admin/invoice_status/screen/invoice_status_screen.dart';
import '../../presentation/view/admin_flow/admin/manage_branches/screen/add_new_branches_screen.dart';
import '../../presentation/view/admin_flow/admin/manage_branches/screen/manage_branches_screen.dart';
import '../../presentation/view/admin_flow/admin/manage_delivery/screen/manage_delivery_screen.dart';
import '../../presentation/view/admin_flow/admin/order/screen/order_summary_screen.dart';
import '../../presentation/view/admin_flow/admin/order/screen/order_summary_view_screen.dart';
import '../../presentation/view/admin_flow/admin/order/screen/order_summary_view_successful_screen.dart';
import '../../presentation/view/admin_flow/admin/profile/screen/head_office_change_info_change.dart';
import '../../presentation/view/admin_flow/admin/profile/screen/head_office_change_password_screen.dart';
import '../../presentation/view/admin_flow/admin/profile/screen/head_office_profile_screen.dart';
import '../../presentation/view/admin_flow/admin/stock/screen/edit_stock_screen.dart';
import '../../presentation/view/auth/forget_password/screen/forget_password_screen.dart';
import '../../presentation/view/auth/login/screen/login_screen.dart';
import '../../presentation/view/auth/otp_verify/screen/otp_verify_screen.dart';
import '../../presentation/view/auth/set_new_password/screen/set_new_password_screen.dart';
import '../../presentation/view/auth/signup/screen/signup_screen.dart';
import '../../presentation/view/branch_manager_flow/Invoice/Invoice_screen.dart';
import '../../presentation/view/branch_manager_flow/Invoice/screens/view_details.dart';
import '../../presentation/view/branch_manager_flow/home/home_screen.dart';
import '../../presentation/view/branch_manager_flow/notification/notification_screen.dart';
import '../../presentation/view/branch_manager_flow/orders/orders_screen.dart';
import '../../presentation/view/branch_manager_flow/orders/screens/my_orders.dart';
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
import '../../presentation/view/onboarding/onboarding/screen/onboarding_screen.dart';
import '../../presentation/view/splash/splash/screen/splash_screen.dart';

class AppRoutes{

  static final Map<String,WidgetBuilder> routes ={

    RouteNames.splashScreen:(context)=>const SplashScreen(),
    RouteNames.onboardingScreen:(context)=>const OnboardingScreen(),
    RouteNames.signUpScreen:(context)=> SignUpScreen(),
    RouteNames.loginScreen :(context)=> LoginScreen (),
    RouteNames.forgetPasswordScreen  :(context)=>  ForgetPasswordScreen (),
    RouteNames.otpVerifyScreen  :(context)=>  OtpVerifyScreen(),
    RouteNames.setNewPasswordScreen   :(context)=>  SetNewPasswordScreen (),
    RouteNames.mainWrapper   :(context)=>  MainWrapper(),
    RouteNames.branchHomeScreen   :(context)=>  BranchHomeScreen(),
    RouteNames.branchParentScreen   :(context)=>  BranchParentScreen(),
    RouteNames.bottomNavBar   :(context)=>  BottomNavBar(),
    RouteNames.ordersScreen   :(context)=>  OrdersScreen(),
    RouteNames.myOrders   :(context)=>  MyOrders(),
    RouteNames.invoiceScreen   :(context)=>  InvoiceScreen(),
    RouteNames.viewDetails   :(context)=>  ViewDetails(),
    RouteNames.profileScreen   :(context)=>  ProfileScreen(),
    RouteNames.changePassword   :(context)=>  ChangePassword(),
    RouteNames.changeInfo   :(context)=>  ChangeInfo(),
    RouteNames.notificationScreen   :(context)=>  NotificationScreen(),
    RouteNames.driverScreen   :(context)=>  DriverScreen(),
    RouteNames.driverBottomNavBar   :(context)=>  DriverBottomNavBar(),
    RouteNames.driverBranchParentScreen   :(context)=>  DriverBranchParentScreen(),
    RouteNames.editStockScreen   :(context)=>  EditStockScreen (),
    RouteNames.driverBranseDetailScreen   :(context)=>  DriverBranchDetailScreen(),
    RouteNames.orderSummaryScreen   :(context)=>  OrderSummaryScreen(),
    RouteNames.orderSummaryViewScreen  :(context)=>  OrderSummaryViewScreen(),
    RouteNames.confirmDeliveryScreen   :(context)=>  ConfirmDeliveryScreen(),
    RouteNames.deliverySummeryScreen   :(context)=>  DeliverySummeryScreen(),
    RouteNames.orderSummaryViewSuccessfulScreen  :(context)=>  OrderSummaryViewSuccessfulScreen(),
    RouteNames.headOfficeInvoiceScreen  :(context)=>  HeadOfficeInvoiceScreen(),
    RouteNames.manageBranchesScreen  :(context)=>  ManageBranchesScreen(),
    RouteNames.addNewBranchesScreen  :(context)=>  AddNewBranchesScreen(),
    RouteNames.invoiceStatusScreen :(context)=>  InvoiceStatusScreen(),
    RouteNames.headOfficeProfileScreen :(context)=>  HeadOfficeProfileScreen(),
    RouteNames.headOfficeChangePasswordScreen :(context)=>  HeadOfficeChangePasswordScreen(),
    RouteNames.headOfficeChangeInfoScreen :(context)=>  HeadOfficeChangeInfoScreen(),
    RouteNames.manageDeliveryScreen:(context)=>  ManageDeliveryScreen(),


  };



}