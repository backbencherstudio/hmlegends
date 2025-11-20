import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecase/get_product_usecase.dart';
import '../../presentation/view/admin_flow/view_model/auth/login_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth/set_new_password_viewModel.dart';
import '../../presentation/view/admin_flow/view_model/auth/signup_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/forget_password_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/login_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/register_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/set_new_pass_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/auth_api/verify_otp_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/home/home_screen_provider.dart';
import '../../presentation/view/admin_flow/view_model/order/order_screen_provider.dart';
import '../../presentation/view/admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/parent/manage_delivery_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/parent/stock_viewmodel.dart';
import '../../presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import '../../presentation/view/admin_flow/view_model/stock/stock_screen_provider.dart';
import '../../presentation/view/branch_manager_flow/Invoice/view_model/get_all_invoice_viewmodel.dart';
import '../../presentation/view/driver_flow/driver_provider/branch_product_provider.dart';

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
    ChangeNotifierProvider(create: (_) => InvoiceViewModel()),
  ];

  static List<SingleChildWidget> getProviders() {
    return providers;
  }
}
