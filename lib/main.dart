import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/constant/app_colors.dart';
import 'core/provider/app_providers.dart';
import 'core/route/app_routes.dart';
import 'core/route/route_names.dart';
import 'firebase_options.dart';


Future<void> main() async {
  // Ensure proper widget binding before Firebase init
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Ensure ScreenUtil can access device metrics
  await ScreenUtil.ensureScreenSize();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders.getProviders().isNotEmpty
        ? MultiProvider(
      providers: AppProviders.getProviders(),
      child: _buildScreenUtilInit(),
    )
        : _buildScreenUtilInit();
  }

  /// Common ScreenUtilInit builder
  Widget _buildScreenUtilInit() {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375, 812),
      builder: (context, child) => _buildMaterialApp(),
    );
  }

  /// Common MaterialApp configuration
  Widget _buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      initialRoute: RouteNames.splashScreen,
      routes: AppRoutes.routes,
      onUnknownRoute: (settings) {
        debugPrint('Attempted to navigate to unknown route: ${settings.name}');
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Route Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No route defined for: ${settings.name}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, RouteNames.splashScreen),
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}