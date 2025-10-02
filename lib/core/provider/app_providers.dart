import 'package:provider/single_child_widget.dart';

class AppProviders {

  static final List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => getIt<ParentScreensProvider>()),



  ];
  static List<SingleChildWidget> getProviders() {
    return providers;
  }

}