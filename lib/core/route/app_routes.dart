import 'package:flutter/material.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/auth/splash/screen/splash_screen.dart';

import '../../presentation/view/auth/onboarding/screen/onboarding_screen.dart';
import '../../presentation/view/auth/signup/screen/signup_screen.dart';

class AppRoutes{

  static final Map<String,WidgetBuilder> routes ={

    RouteNames.splashScreen:(context)=>const SplashScreen(),
    RouteNames.onboardingScreen:(context)=>const OnboardingScreen(),
    RouteNames.signUpScreen:(context)=> SignUpScreen(),


  };



}