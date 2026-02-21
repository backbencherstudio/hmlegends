import 'package:hmlegends/presentation/view/branch_manager_flow/orders/viewmodel/create_order_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../presentation/view/admin_flow/admin/invoice/view_model/admin_invoice_provider.dart';
import '../../presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import '../../presentation/view/admin_flow/view_model/auth/login_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth/set_new_password_viewModel.dart';
import '../../presentation/view/admin_flow/view_model/auth/signup_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/forget_password_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/login_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/register_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/set_new_pass_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/verify_otp_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/home/home_screen_provider.dart';
import '../../presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import '../../presentation/view/admin_flow/view_model/order/order_screen_provider.dart';
import '../../presentation/view/admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/parent/manage_delivery_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import '../../presentation/view/admin_flow/view_model/stock/stock_screen_provider.dart';
import '../../presentation/view/branch_manager_flow/Invoice/view_model/get_all_invoice_viewmodel.dart';
import '../../presentation/view/branch_manager_flow/Invoice/view_model/get_invoices_details_viewmodel.dart';
import '../../presentation/view/branch_manager_flow/Invoice/view_model/paid_payment_viewmodel.dart';
import '../../presentation/view/branch_manager_flow/orders/viewmodel/get_all_product_viewmodel.dart';
import '../../presentation/view/branch_manager_flow/orders/viewmodel/get_my_orders_viewmodel.dart';
import '../../presentation/view/driver_flow/driver_provider/branch_product_provider.dart';
import '../../presentation/view/driver_flow/model_view/delivery_provideer_Admin.dart';
import '../../presentation/view/driver_flow/model_view/driver_profile_screen_provider.dart';
import '../../presentation/view/driver_flow/tracking/tracking_provider.dart';
class AppProviders {
  static final List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => getIt<ParentScreensProvider>()),
    ChangeNotifierProvider(create: (_) => SignUpViewModel()),
    ChangeNotifierProvider(create: (_) => LoginViewModel()),
    ChangeNotifierProvider(create: (_) => SetNewPasswordViewModel()),
    ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
    ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
    ChangeNotifierProvider(create: (_) => BranchProductProvider()),
    ChangeNotifierProvider(create: (_) => ManageDeliveryViewModel()),

    //auth_api
    ChangeNotifierProvider(create: (_) => RegisterProvider()),
    ChangeNotifierProvider(create: (_) => LoginScreenProvider()),
    ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
    ChangeNotifierProvider(create: (_) => VerifyOtpViewmodel()),
    ChangeNotifierProvider(create: (_) => SetNewPasswordViewModel()),
    ChangeNotifierProvider(create: (_) => SetPasswordViewModel()),

    ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
    ChangeNotifierProvider(create: (_) => StockScreenProvider()),
    ChangeNotifierProvider(create: (_) => OrderScreenProvider()),
    ChangeNotifierProvider(create: (_) => GetAllInvoiceProvider()),
    ChangeNotifierProvider(create: (_) => GetInvoiceDetailViewmodel()),
    ChangeNotifierProvider(create: (_) => GetProductsViewmodel()),
    ChangeNotifierProvider(create: (_) => OrderViewmodel()),
    ChangeNotifierProvider(create: (_) => GetOrdersViewModel()),
    ChangeNotifierProvider(create: (_) => PayInvoiceViewModel()),
    ChangeNotifierProvider(create: (_) => AdminInvoiceProvider()),
    ChangeNotifierProvider(create: (_) => DeliveryProviderAdmin()),
    ChangeNotifierProvider(create: (_) => DriverProfileScreenProvider()),
    ChangeNotifierProvider(create: (_) => AdminNotificationProvider()),
    ChangeNotifierProvider(create: (_) => TrackingProvider()),
    ChangeNotifierProvider(create: (_) => ManageBranchProvider()),
  ];

  static List<SingleChildWidget> getProviders() {
    return providers;
  }
}
