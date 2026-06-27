import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/core/services/user_type_storage.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _gradientController;
  late Animation<Color?> _topColor;
  late Animation<Color?> _bottomColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final startTime = DateTime.now();
      final token = await TokenStorage().getToken();

      debugPrint("Token in splash screen: $token");
      final userType = await UserTypeStorage().getUserType();
      debugPrint("User type in splash screen: $userType");

      if (token != null && userType == "admin") {
        // ignore: use_build_context_synchronously
        await context.read<ChangePasswordProvider>().adminCheckMe();
      }

      final elapsed = DateTime.now().difference(startTime);
      final remaining = const Duration(seconds: 5) - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }

      if (!mounted) return;

      if (token != null && userType == "admin") {
        Navigator.pushReplacementNamed(context, RouteNames.mainWrapper);
      } else if (token != null && userType == 'manager') {
        Navigator.pushReplacementNamed(context, RouteNames.branchParentScreen);
      } else if (token != null && userType == "driver") {
        Navigator.pushReplacementNamed(
          context,
          RouteNames.driverBottomNavScreen,
        );
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.onboardingScreen);
      }
    });

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _zoomController, curve: Curves.easeIn));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _topColor = ColorTween(
      begin: const Color(0xFF613A19),
      end: const Color(0xFF613A19),
    ).animate(_gradientController);

    _bottomColor = ColorTween(
      begin: const Color(0xFF151517),
      end: const Color(0xFF151517),
    ).animate(_gradientController);

    // Run animations
    _gradientController.forward();
    _zoomController.forward().whenComplete(() {
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _pulseController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _pulseAnimation,
        _gradientController,
      ]),
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_topColor.value!, _bottomColor.value!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value * _pulseAnimation.value,
                  child: Image.asset(
                    AssetPaths.appLogo,
                    height: 113.h,
                    width: 113.w,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
