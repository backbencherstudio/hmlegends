import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../widget/onboarding_elevated_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onGetStartedPressed() {
    // Navigate to main app from second screen
        Navigator.pushNamed(context, RouteNames.signUpScreen);
  }

  void _onButton1Pressed() {
    // Handle button 1 action
    print('Start as Admin pressed');
    _onGetStartedPressed();
  }

  void _onButton2Pressed() {
    // Handle button 2 action
    print('Start as Branch manager pressed');
    _onGetStartedPressed();
  }

  void _onButton3Pressed() {
    // Handle button 3 action
    print('Start as Driver pressed');
    _onGetStartedPressed();
  }

  void _onNextPressed() {
    // Navigate to second onboarding screen
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _currentPage == 0
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
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    // Page 1: Logo and Single Button
                    _buildPage1(),

                    // Page 2: Logo and 3 Buttons
                    _buildPage2(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildPage1Decoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF613A19), Color(0xFF161618)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  BoxDecoration _buildPage2Decoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF0F1016), // Up color
          Color(0xFF77161A), // Down color
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  // Page 1: Logo and Single Button below logo
  Widget _buildPage1() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(AssetPaths.appLogo, height: 113.h, width: 113.w),

          SizedBox(height: 40.h),

          // Get Started Button below logo
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
  }

  // Page 2: Logo and 3 Buttons
  Widget _buildPage2() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(AssetPaths.appLogo, height: 113.h, width: 113.w),

          SizedBox(height: 40.h),
          // Button 1 - Admin
          OnBoardingElevatedButton(
            text: 'Start as Admin',
            suffixIcon: Icons.arrow_forward,
            onPressed: _onButton1Pressed,
            height: 49.h,
            width: 240.w,
            borderRadius: 30.r,
          ),

          SizedBox(height: 20.h),

          // Button 2 - Branch Manager
          OnBoardingElevatedButton(
            text: 'Start as Branch manager',
            suffixIcon: Icons.arrow_forward,
            onPressed: _onButton2Pressed,
            height: 49.h,
            width: 280.w,
            borderRadius: 30.r,
          ),

          SizedBox(height: 20.h),

          // Button 3 - Driver
          OnBoardingElevatedButton(
            text: 'Start as Driver',
            suffixIcon: Icons.arrow_forward,
            onPressed: _onButton3Pressed,
            height: 49.h,
            width: 220.w,
            borderRadius: 30.r,
          ),
        ],
      ),
    );
  }
}
