import 'package:hmlegends/presentation/view/admin_flow/admin/manage_delivery/view_model/delivery_provider.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/orders/viewmodel/create_order_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../presentation/view/admin_flow/admin/invoice/view_model/admin_invoice_provider.dart';
import '../../presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import '../../presentation/view/admin_flow/view_model/auth/login_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth/new_password_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/forget_password_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth/register_viewmodel.dart';
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
import '../../presentation/view/branch_manager_flow/delivery_progress/viewmodel/delivery_progress_viewmodel.dart';
import '../../presentation/view/drivier_flow/driver_bottom_nav/viewmodel/driver_bottom_nav_provider.dart';
import '../../presentation/view/drivier_flow/driver_home/viewmodel/driver_home_viewmodel.dart';
import '../../presentation/view/drivier_flow/driver_home/viewmodel/driver_branch_detail_viewmodel.dart';
import '../../presentation/view/drivier_flow/driver_home/viewmodel/driver_notification_provider.dart';

class AppProviders {
  static final List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => getIt<ParentScreensProvider>()),
    ChangeNotifierProvider(create: (_) => LoginViewModel()),
    ChangeNotifierProvider(create: (_) => SetNewPasswordViewModel()),
    ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
    ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
    ChangeNotifierProvider(create: (_) => ManageDeliveryViewModel()),

    //auth_api
    ChangeNotifierProvider(create: (_) => RegisterProvider()),
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
    ChangeNotifierProvider(create: (_) => DeliveryProvider()),
    ChangeNotifierProvider(create: (_) => AdminNotificationProvider()),
    ChangeNotifierProvider(create: (_) => ManageBranchProvider()),
    ChangeNotifierProvider(create: (_) => DeliveryProgressViewModel()),
    ChangeNotifierProvider(create: (_) => DriverBottomNavProvider()),
    ChangeNotifierProvider(create: (_) => DriverHomeViewModel()),
    ChangeNotifierProvider(create: (_) => DriverBranchDetailViewModel()),
    ChangeNotifierProvider(create: (_) => DriverNotificationProvider()),
  ];

  static List<SingleChildWidget> getProviders() {
    return providers;
  }
}
