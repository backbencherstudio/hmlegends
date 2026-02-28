import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/widget/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/route/route_names.dart';
import '../../../admin_flow/view_model/auth/login_viewmodel.dart';
import '../../widget/auth_button.dart';
import '../../widget/level_text.dart';
import '../../widget/social_auth_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                Center(
                  child: Image.asset(
                    AssetPaths.authLogo,
                    width: 100.w,
                    height: 100.h,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Let’s get you started!',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Color(0xFF4A4C56),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please, enter email and password to sign in',
                  style: AppTextStyles.authBodyText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),

                /// ----------- Wrap Form Widget with Consumer -----------------
                Consumer<LoginViewModel>(
                  builder: (context, viewModel, child) {
                    return Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RequiredLabel(labelText: 'Email'),
                          SizedBox(height: 5.h),
                          customTextFormField(
                            hintText: 'Enter your email',
                            controller: viewModel.emailController,
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: emailValidator,
                          ),
                          SizedBox(height: 8.h),
                          RequiredLabel(labelText: 'Password'),
                          SizedBox(height: 5.h),
                          customTextFormField(
                            hintText: 'Enter your password',
                            controller: viewModel.passwordController,
                            prefixIcon: const Icon(Icons.lock_outline),
                            isPassword: !viewModel.passwordVisible,
                            validator: passwordValidator,
                            suffixIcon: GestureDetector(
                              onTap: viewModel.togglePasswordVisibility,
                              child: Icon(
                                viewModel.passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.authBodyTextColor,
                              ),
                            ),
                          ),

                          SizedBox(height: 5.h),
                          _buildRememberMeRow(),
                          SizedBox(height: 10.h),
                          _buildSignInButton(),
                          SizedBox(height: 20.h),
                          _buildOrJoinWithDivider(),
                          SizedBox(height: 20.h),
                          const SocialAuthButtons(),
                          SizedBox(height: 30.h),
                          _buildSignUpLink(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ------------------ Build Remember Me Row Widget --------------------------
  Widget _buildRememberMeRow() {
    return Row(
      children: [
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.forgetPasswordScreen);
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.authHeaderTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- Build Sign In Button ------------------------------------
  Widget _buildSignInButton() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return AuthButton(
          text:
              viewModel.isLoading
                  ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                  : Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final res = await viewModel.login(
                email: viewModel.emailController.text.trim(),
                password: viewModel.passwordController.text,
              );
              if (res.success) {
                Fluttertoast.showToast(
                  msg: res.message,
                  backgroundColor: Colors.green,
                );

                viewModel.emailController.clear();
                viewModel.passwordController.clear();
                final userRole = viewModel.userType ?? '';
                if (userRole == 'admin') {
                  Navigator.pushNamed(context, RouteNames.mainWrapper);
                } else if (userRole == 'manager') {
                  Navigator.pushNamed(context, RouteNames.branchParentScreen);
                } else if (userRole == 'driver') {
                  Navigator.pushNamed(
                    context,
                    RouteNames.driverBranchParentScreen,
                  );
                } else {
                  Navigator.pushNamed(context, RouteNames.mainWrapper);
                }
              } else {
                Fluttertoast.showToast(
                  msg: res.message,
                  backgroundColor: Colors.red,
                );
              }
            }
          },
          color: AppColors.primaryColor,
        );
      },
    );
  }

  /// -------------- Build Or Join With Divider --------------------------------
  Widget _buildOrJoinWithDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.authTextFormFieldBorderColor,
            thickness: 1.0,
            indent: 4.0,
            endIndent: 7.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            'Or',
            style: TextStyle(
              color: const Color(0xFF777980),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.authTextFormFieldBorderColor,
            thickness: 1.0,
            indent: 7.0,
            endIndent: 4.0,
          ),
        ),
      ],
    );
  }

  /// -------------------- Build Sign Up Link ----------------------------------
  Widget _buildSignUpLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Haven’t an account?',
              style: AppTextStyles.hintText,
            ),
            TextSpan(
              text: ' Sign Up',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, RouteNames.signUpScreen);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
