import 'package:hmlegends/presentation/view_model/auth/signup_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecase/get_product_usecase.dart';
import '../../presentation/view_model/auth/login_viewmodel.dart';
import '../../presentation/view_model/auth/set_new_password_viewModel.dart';
import '../../presentation/view_model/parent/bottom_nav_viewmodel.dart';
import '../../presentation/view_model/parent/stock_viewmodel.dart';

class AppProviders {
  static final List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => getIt<ParentScreensProvider>()),
    ChangeNotifierProvider(create: (_) => SignUpViewModel()),
    ChangeNotifierProvider(create: (_) => LoginViewModel()),
    ChangeNotifierProvider(create: (_) => SetNewPasswordViewModel()),
    ChangeNotifierProvider(create: (_) => BottomNavViewModel()),

    ChangeNotifierProvider(
      create: (_) => StockViewModel(
        GetProductsUseCase(ProductRepositoryImpl(ProductLocalDataSource())),
      ),
    ),

  ];

  static List<SingleChildWidget> getProviders() {
    return providers;
  }
}
