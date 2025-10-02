import 'package:hmlegends/presentation/view_model/auth/signup_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {

  static final List<SingleChildWidget> providers = [
     ChangeNotifierProvider(create: (_) => SignUpViewModel()),



  ];
  static List<SingleChildWidget> getProviders() {
    return providers;
  }

}