import 'package:flutter/material.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/auth/splash/screen/splash_screen.dart';

import '../../presentation/view/auth/forget_password/screen/forget_password_screen.dart';
import '../../presentation/view/auth/login/screen/login_screen.dart';
import '../../presentation/view/auth/onboarding/screen/onboarding_screen.dart';
import '../../presentation/view/auth/otp_verify/screen/otp_verify_screen.dart';
import '../../presentation/view/auth/set_new_password/screen/set_new_password_screen.dart';
import '../../presentation/view/auth/signup/screen/signup_screen.dart';

class AppRoutes{

  static final Map<String,WidgetBuilder> routes ={

    RouteNames.splashScreen:(context)=>const SplashScreen(),
    RouteNames.onboardingScreen:(context)=>const OnboardingScreen(),
    RouteNames.signUpScreen:(context)=> SignUpScreen(),
    RouteNames.loginScreen :(context)=> LoginScreen (),
    RouteNames.forgetPasswordScreen  :(context)=>  ForgetPasswordScreen (),
    RouteNames.otpVerifyScreen  :(context)=>  OtpVerifyScreen(),
    RouteNames.setNewPasswordScreen   :(context)=>  SetNewPasswordScreen (),


  };



}