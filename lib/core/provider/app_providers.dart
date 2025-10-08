import 'package:hmlegends/presentation/view_model/auth/signup_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../presentation/view_model/auth/login_viewmodel.dart';
import '../../presentation/view_model/auth/set_new_password_viewModel.dart';
import '../../presentation/view_model/parent/bottom_nav_viewmodel.dart';

class AppProviders {
  static final List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => getIt<ParentScreensProvider>()),
    ChangeNotifierProvider(create: (_) => SignUpViewModel()),
    ChangeNotifierProvider(create: (_) => LoginViewModel()),
    ChangeNotifierProvider(create: (_) => SetNewPasswordViewModel()),
    ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
  ];

  static List<SingleChildWidget> getProviders() {
    return providers;
  }
}
