import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../view_model/auth_api/forget_password_viewmodel.dart';
import '../../widget/auth_button.dart';
import '../../widget/level_text.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForgetPasswordProvider>(context);

    return Scaffold(
      body: Padding(
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
              Text('Forgot Password', style: AppTextStyles.authHeadline),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Please enter your email to reset the password',
                      style: AppTextStyles.authBodyText.copyWith(fontSize: 15.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Email Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RequiredLabel(labelText: 'Email'),
                  SizedBox(height: 8.h),
                  _buildTextField('Your email', Icons.email_outlined, _emailController),
                  SizedBox(height: 20.h),

                  // Reset Button
                  provider.isFPLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.green))
                      : _resetPasswordButton(context, provider),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resetPasswordButton(BuildContext context, ForgetPasswordProvider provider) {
    return AuthButton(
      text: 'Reset Password',
      color: AppColors.primaryColor,
      onPressed: () async {
        final email = _emailController.text.trim();

        if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter your email"), backgroundColor: Colors.red),
          );
          return;
        }

        final success = await provider.forgetPassword(email: email);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: success ? Colors.green : Colors.red,
            content: Text(provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : success
                ? 'Password reset link sent successfully!'
                : 'Something went wrong.'),
          ),
        );

        if (success && mounted) {
          Navigator.pushNamed(context, RouteNames.otpVerifyScreen);
        }
      },
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.hintText,
          filled: true,
          fillColor: AppColors.authTextFormFieldFillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(color: AppColors.authTextFormFieldBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(color: AppColors.authTextFormFieldBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(color: AppColors.authTextFormFieldBorderColor),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Icon(icon, color: AppColors.authBodyTextColor),
          ),
        ),
      ),
    );
  }
}
