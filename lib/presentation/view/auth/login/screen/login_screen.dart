import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/route/route_names.dart';
import '../../../../view_model/auth/login_viewmodel.dart';
import '../../widget/auth_button.dart';
import '../../widget/level_text.dart';
import '../../widget/social_auth_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  style: AppTextStyles.authHeadline,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please, enter email and password to sign in',
                  style: AppTextStyles.authBodyText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    RequiredLabel(labelText: 'Email'),
                    SizedBox(height: 5.h),
                    _buildTextField('Your email', Icons.email_outlined),
                    SizedBox(height: 8.h),
                    RequiredLabel(labelText: 'Password'),
                    SizedBox(height: 5.h),
                    _buildPasswordField(),
                    SizedBox(height: 5.h),
                    _buildRememberMeRow(),
                    SizedBox(height: 10.h),
                  ],
                ),
                SizedBox(height: 10.h),
                _buildSignInButton(),
                SizedBox(height: 20.h),
                _buildOrJoinWithDivider(),
                SizedBox(height: 20.h),
                SocialAuthButtons(),
                SizedBox(height: 30.h),
                _buildSignUpLink(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return TextField(
          obscureText: !viewModel.passwordVisible,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: AppTextStyles.hintText,
            filled: true,
            fillColor: AppColors.authTextFormFieldFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide(
                color: AppColors.authTextFormFieldBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide(
                color: AppColors.authTextFormFieldBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide(
                color: AppColors.authTextFormFieldBorderColor,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 16.w,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(
                Icons.lock_outline_rounded,
                color: AppColors.authBodyTextColor,
              ),
            ),
            suffixIcon: IconButton(
              padding: EdgeInsets.only(right: 8.w),
              icon: Icon(
                viewModel.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.authBodyTextColor,
              ),
              onPressed: () {
                viewModel.togglePasswordVisibility();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRememberMeRow() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: viewModel.rememberMe,
                onChanged: (value) {
                  viewModel.setRememberMe(value ?? false);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                side: BorderSide(color: AppColors.primaryColor),
                activeColor: AppColors.primaryColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              ),
            ),
            SizedBox(width: 10.w), // Spacing
            Text(
              'Remember me',
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 0.5,
                color: AppColors.authBodyTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.forgetPasswordScreen);
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 12.sp,
                  letterSpacing: 0.5,
                  color: AppColors.authHeaderTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignInButton() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return AuthButton(
          text: 'Sign In',
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.mainWrapper);
          },
          color: AppColors.primaryColor,
        );
      },
    );
  }

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
            textAlign: TextAlign.center,
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

  Widget _buildTextField(String hint, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.hintText,
          filled: true,
          fillColor: AppColors.authTextFormFieldFillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(
              color: AppColors.authTextFormFieldBorderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(
              color: AppColors.authTextFormFieldBorderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(
              color: AppColors.authTextFormFieldBorderColor,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Icon(icon, color: AppColors.authBodyTextColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Haven\’t an account?',
              style: AppTextStyles.hintText,
            ),
            TextSpan(
              text: ' Sign Up',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
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
