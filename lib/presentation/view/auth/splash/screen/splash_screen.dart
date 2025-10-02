// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hmlegends/core/constant/asset_path.dart';
//
// import '../widget/onboarding_elevated_button.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _zoomController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;
//
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;
//
//   late AnimationController _gradientController;
//   late Animation<Color?> _topColor;
//   late Animation<Color?> _bottomColor;
//
//   bool _showGetStartedButton = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _zoomController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
//     );
//
//     _opacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _zoomController, curve: Curves.easeIn));
//
//     _zoomController.forward().whenComplete(() {
//       _pulseController.repeat(reverse: true);
//     });
//
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
//
//     _gradientController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );
//
//     _topColor = ColorTween(
//       begin: const Color(0xFF613A19),
//       end: const Color(0xFF613A19),
//     ).animate(_gradientController);
//
//     _bottomColor = ColorTween(
//       begin: const Color(0xFF151517),
//       end: const Color(0xFF151517),
//     ).animate(_gradientController);
//
//     _gradientController.forward();
//
//     // Stop animations after 2 seconds and show button
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() {
//           _showGetStartedButton = true;
//         });
//         _pulseController.stop();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _zoomController.dispose();
//     _pulseController.dispose();
//     _gradientController.dispose();
//     super.dispose();
//   }
//
//   void _onGetStartedPressed() {
//     // Navigator.of(context).pushReplacement(
//     //   MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _scaleAnimation,
//         _pulseAnimation,
//         _gradientController,
//       ]),
//       builder: (context, child) {
//         final currentScale = _showGetStartedButton
//             ? 1.0
//             : _scaleAnimation.value * _pulseAnimation.value;
//         final currentOpacity = _showGetStartedButton
//             ? 1.0
//             : _opacityAnimation.value;
//
//         return Scaffold(
//           body: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [_topColor.value!, _bottomColor.value!],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 stops: const [0.0, 1.0],
//               ),
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Opacity(
//                     opacity: currentOpacity,
//                     child: Transform.scale(
//                       scale: currentScale,
//                       child: Image.asset(
//                         AssetPaths.appLogo,
//                         height: 113.h,
//                         width: 113.w,
//                         scale: 2.5,
//                       ),
//                     ),
//                   ),
//
//                   // Animated Get Started Button with new specifications
//                   if (_showGetStartedButton)
//                     Padding(
//                       padding: EdgeInsets.only(top: 45.h),
//                       child: AnimatedOpacity(
//                         opacity: _showGetStartedButton ? 1.0 : 0.0,
//                         duration: const Duration(milliseconds: 500),
//                         child: CustomElevatedButton(
//                           text: 'Get Started',
//                           suffixIcon: Icons.arrow_forward,
//                           onPressed: _onGetStartedPressed,
//                           height: 49.h,
//                           width: 210.w,
//                           borderRadius: 30, // Radius 30
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';

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

    _zoomController.forward().whenComplete(() {
      _pulseController.repeat(reverse: true);
    });

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

    _gradientController.forward();

    // Navigate to onboarding after animations complete (2-3 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.onboardingScreen);
      }
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
        final currentScale = _scaleAnimation.value * _pulseAnimation.value;
        final currentOpacity = _opacityAnimation.value;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_topColor.value!, _bottomColor.value!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 1.0],
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: currentOpacity,
                child: Transform.scale(
                  scale: currentScale,
                  child: Image.asset(
                    AssetPaths.appLogo,
                    height: 113.h,
                    width: 113.w,
                    scale: 2.5,
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