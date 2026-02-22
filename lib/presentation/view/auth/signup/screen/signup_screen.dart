import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/widget/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../../../../core/constant/asset_path.dart';
import '../../../../../core/route/route_names.dart';
import '../../../../../core/utlis/utils.dart';
import '../../../admin_flow/view_model/auth/register_viewmodel.dart';
import '../../widget/auth_button.dart';
import '../../widget/social_auth_buttons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                Image.asset(AssetPaths.authLogo, width: 100.w, height: 100.h),
                SizedBox(height: 20.h),
                Text(
                  'Let\'s get you started!',
                  style: AppTextStyles.authHeadline,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter info to create a new account.',
                  style: AppTextStyles.authBodyText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                _buildFormFields(),
                SizedBox(height: 24.h),
                _buildSignUpButton(),
                SizedBox(height: 20.h),
                _buildOrJoinWithDivider(),
                SizedBox(height: 20.h),
                const SocialAuthButtons(),
                SizedBox(height: 30.h),
                _buildSignInLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Full Name'),
              SizedBox(height: 6.h),
              customTextFormField(
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person_outline),
                controller: provider.nameController,
                validator: nameValidator,
              ),
              SizedBox(height: 12.h),
              _label('Email'),
              SizedBox(height: 6.h),
              customTextFormField(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                controller: provider.emailController,
                validator: emailValidator,
              ),
              SizedBox(height: 12.h),
              _label('Password'),
              SizedBox(height: 6.h),
              customTextFormField(
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock_outline),
                controller: provider.passwordController,
                isPassword: true,
                showSuffixIcon: true,
                validator: passwordValidator,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _label(String text) => Text(text, style: AppTextStyles.appHeaderText);

  Widget _buildSignUpButton() => Consumer<RegisterProvider>(
    builder: (context, provider, child) {
      return AuthButton(
        text:
            provider.isLoading
                ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
                : Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var res = await provider.registerUser(
              name: provider.nameController.text.trim(),
              email: provider.emailController.text.trim(),
              password: provider.passwordController.text.trim(),
            );

            if (res.success) {
              Utils.showToast(
                msg: res.message,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            } else {
              Utils.showToast(
                msg: res.message,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          }
        },
        color: AppColors.primaryColor,
      );
    },
  );

  Widget _buildOrJoinWithDivider() => Row(
    children: const [
      Expanded(child: Divider(color: AppColors.authTextFormFieldBorderColor)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text('Or'),
      ),
      Expanded(child: Divider(color: AppColors.authTextFormFieldBorderColor)),
    ],
  );

  Widget _buildSignInLink() => Center(
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'Have an account?', style: AppTextStyles.hintText),
          TextSpan(
            text: ' Sign In',
            style: const TextStyle(color: AppColors.primaryColor),
            recognizer:
                TapGestureRecognizer()
                  ..onTap =
                      () =>
                          Navigator.pushNamed(context, RouteNames.loginScreen),
          ),
        ],
      ),
    ),
  );
}
