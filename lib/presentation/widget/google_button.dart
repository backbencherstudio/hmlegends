import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/route/route_names.dart';
import '../../core/services/auth_services.dart';
import '../view/admin_flow/view_model/auth/login_viewmodel.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, this.alwaysShowChooser = true});

  final bool alwaysShowChooser;

  @override
  Widget build(BuildContext context) {
    final authServices = AuthServices();

    return Consumer<LoginViewModel>(
      builder: (context, loginProvider, _) {
        final isLoading = loginProvider.isLoadingForGoogle;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F7),
            borderRadius: BorderRadius.circular(32.r),
          ),
          child: InkWell(
            onTap:
                isLoading
                    ? null
                    : () async {
                      loginProvider.setLoadingForGoogle(true);

                      try {
                        final userCredential = await authServices
                            .loginWithGoogle(
                              forceAccountPicker: alwaysShowChooser,
                            );

                        final user = FirebaseAuth.instance.currentUser;

                        if (userCredential != null && user != null) {
                          final firebaseToken = await user.getIdToken();

                          final result = await loginProvider.googleSignIn(
                            firebaseToken: firebaseToken,
                          );

                          if (result['success'] == true && context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteNames.driverBottomNavBar,
                              (route) => false,
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result['message'] ??
                                      "Google sign-in failed. Please try again.",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Google sign-in failed. Please try again.",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login failed: $error"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        loginProvider.setLoadingForGoogle(false);
                      }
                    },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child:
                      isLoading
                          ? SizedBox(
                            key: const ValueKey('spinner'),
                            height: 22.h,
                            width: 22.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                          : Image.asset(
                            'assets/icons/google_icon.png',
                            key: const ValueKey('icon'),
                            height: 25.h,
                            width: 25.h,
                          ),
                ),
                SizedBox(width: 10.w),
                Text(
                  isLoading ? "Signing in..." : "Sign in with Google",
                  style: TextStyle(
                    color: const Color(0xff404148),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
