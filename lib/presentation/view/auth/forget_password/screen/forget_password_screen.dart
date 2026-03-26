import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/validator/validator.dart';
import '../../../../widget/custom_text_form_field.dart';
import '../../../admin_flow/view_model/auth_api/forget_password_viewmodel.dart';
import '../../widget/auth_button.dart';
import '../../widget/level_text.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                      style: AppTextStyles.authBodyText.copyWith(
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Email Field
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RequiredLabel(labelText: 'Email'),
                    SizedBox(height: 8.h),
                    customTextFormField(
                      hintText: 'Enter your email',
                      controller: _emailController,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: emailValidator,
                    ),
                    SizedBox(height: 20.h),

                    ///---------------- Reset Button ---------------------------
                    _resetPasswordButton(context, provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resetPasswordButton(
    BuildContext context,
    ForgetPasswordProvider provider,
  ) {
    return AuthButton(
      text:
          provider.isFPLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
              : Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
      color: AppColors.primaryColor,
      onPressed: () async {
        final email = _emailController.text.trim();

        if (email.isEmpty) {
          Utils.showToast(
            msg: 'Please enter your email',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        final res = await provider.forgetPassword(email: email);

        if (res.success) {
          Utils.showToast(
            msg: res.message,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          if (context.mounted) {
            Navigator.pushNamed(context, RouteNames.otpVerifyScreen);
          }
        } else {
          Utils.showToast(
            msg: res.message,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
    );
  }
}
