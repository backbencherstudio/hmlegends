import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../view_model/auth/set_new_password_viewModel.dart';
import '../../widget/auth_button.dart';
import '../../widget/level_text.dart';

class SetNewPasswordScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: Image.asset(
                    AssetPaths.authLogo,
                    width: 100.w,
                    height: 100.h,
                  ),
                ),
                SizedBox(height: 20.h),
                Text('Set A New Password', style: AppTextStyles.authHeadline),
                SizedBox(height: 8.h),
                Text(
                  'Create a new password. Ensure it differs from previous ones for security',
                  style: AppTextStyles.authBodyText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RequiredLabel(labelText: 'Password'),
                    SizedBox(height: 5.h),
                    _buildPasswordField(),
                    SizedBox(height: 10.h),
                    RequiredLabel(labelText: 'Confirm Password'),
                    SizedBox(height: 5.h),
                    _buildConfirmPasswordField(),
                    SizedBox(height: 5.h),
                    _buildErrorMessage(),
                    SizedBox(height: 20.h),
                    _resetPasswordButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resetPasswordButton(BuildContext context) {
    return Consumer<SetNewPasswordViewModel>(
      builder: (context, viewModel, child) {
        return AuthButton(
          text: 'Update Password',
          onPressed: viewModel.canUpdatePassword()
              ? () {
            Navigator.pushNamed(context, RouteNames.loginScreen);
          }
              : (){},
          color: AppColors.primaryColor,
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Consumer<SetNewPasswordViewModel>(
      builder: (context, viewModel, child) {
        return TextField(
          controller: _passwordController,
          obscureText: !viewModel.passwordVisible,
          onChanged: viewModel.setPassword,
          decoration: InputDecoration(
            hintText: 'Enter Your New Password',
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
              onPressed: viewModel.togglePasswordVisibility,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return Consumer<SetNewPasswordViewModel>(
      builder: (context, viewModel, child) {
        return TextField(
          controller: _confirmPasswordController,
          obscureText: !viewModel.confirmPasswordVisible,
          onChanged: viewModel.setConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Re-enter Your New Password',
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
                viewModel.confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.authBodyTextColor,
              ),
              onPressed: viewModel.toggleConfirmPasswordVisibility,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage() {
    return Consumer<SetNewPasswordViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.errorMessage != null) {
          return Text(
            viewModel.errorMessage!,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12.sp,
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}