import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import '../../auth/widget/onboarding_elevated_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isInitialized = false;
  DateTime? _lastPressedAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['showPage2'] == true) {
        _currentPage = 1;
      }
      _pageController = PageController(initialPage: _currentPage);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToSignUp(String role) {
    Navigator.pushNamed(
      context,
      RouteNames.signUpScreen,
      arguments: {'userRole': role},
    );
  }

  void _onNextPressed() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_currentPage == 1) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          return;
        }

        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrMaxTimeHasPassed =
            _lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrMaxTimeHasPassed) {
          _lastPressedAt = now;
          Utils.showToast(
            msg: "Press back again to exit",
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          return;
        }

        await SystemNavigator.pop();
      },
      child: Scaffold(
        body: Container(
          decoration:
              _currentPage == 0
                  ? _buildPage1Decoration()
                  : _buildPage2Decoration(),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) {
                      setState(() => _currentPage = page);
                    },
                    children: [_buildPage1(), _buildPage2()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildPage1Decoration() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF613A19), Color(0xFF161618)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  BoxDecoration _buildPage2Decoration() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF0F1016), Color(0xFF77161A)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  Widget _buildPage1() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetPaths.appLogo, height: 113.h, width: 113.w),
        SizedBox(height: 40.h),
        OnBoardingElevatedButton(
          text: 'Get Started',
          suffixIcon: Icons.arrow_forward,
          onPressed: _onNextPressed,
          height: 50.h,
          width: 210.w,
          borderRadius: 30.r,
        ),
      ],
    ),
  );

  Widget _buildPage2() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetPaths.appLogo, height: 113.h, width: 113.w),
        SizedBox(height: 40.h),
        OnBoardingElevatedButton(
          text: 'Start as Admin',
          suffixIcon: Icons.arrow_forward,
          onPressed: () => _navigateToSignUp('admin'),
          height: 49.h,
          width: 240.w,
          borderRadius: 30.r,
        ),
        SizedBox(height: 20.h),
        OnBoardingElevatedButton(
          text: 'Start as Branch manager',
          suffixIcon: Icons.arrow_forward,
          onPressed: () => _navigateToSignUp('manager'),
          height: 49.h,
          width: 280.w,
          borderRadius: 30.r,
        ),
        SizedBox(height: 20.h),
        OnBoardingElevatedButton(
          text: 'Start as Driver',
          suffixIcon: Icons.arrow_forward,
          onPressed: () => _navigateToSignUp('driver'),
          height: 49.h,
          width: 220.w,
          borderRadius: 30.r,
        ),
      ],
    ),
  );
}
