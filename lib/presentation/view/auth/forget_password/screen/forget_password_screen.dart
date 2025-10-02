import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';

import '../../../../../core/constant/app_colors.dart';

import '../../widget/auth_button.dart';
import '../../widget/level_text.dart';

class ForgetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
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
              Text('Forgot Password', style: AppTextStyles.authHeadline),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    'Please enter your email to reset the password',
                    style: AppTextStyles.authBodyText,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  RequiredLabel(labelText: 'Email'),
                  SizedBox(height: 8.h),
                  _buildTextField('Your email', Icons.email_outlined),
                  SizedBox(height: 20.h),
                  _resetPasswordButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resetPasswordButton() {
    return AuthButton(
      text: 'Reset Password',
      onPressed: () {
        // Navigator.pushNamed(context, RouteNames.parentScreen);
      },
      color: AppColors.primaryColor,
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
}
