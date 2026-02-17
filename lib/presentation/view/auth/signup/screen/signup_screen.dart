import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../../../../core/constant/asset_path.dart';
import '../../../../../core/route/route_names.dart';
import '../../../admin_flow/view_model/auth_api/register_viewmodel.dart';
import '../../widget/auth_button.dart';
import '../../widget/social_auth_buttons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // @override    // pass the type from onboarding
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   context.read<RegisterProvider>().setTypeFromRoute(context);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegisterProvider>().setTypeFromRoute(context);
    });
  }


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
                Text('Let\'s get you started!', style: AppTextStyles.authHeadline),
                SizedBox(height: 8.h),
                Text('Enter info to create a new account.', style: AppTextStyles.authBodyText, textAlign: TextAlign.center),
                SizedBox(height: 20.h),
                _buildFormFields(),
                SizedBox(height: 10.h),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Full Name'),
            SizedBox(height: 5.h),
            _buildTextField('Your name', Icons.person_outlined, _nameController),
            SizedBox(height: 8.h),
            _label('Email'),
            SizedBox(height: 5.h),
            _buildTextField('Your email', Icons.email_outlined, _emailController),
            SizedBox(height: 8.h),
            _label('Password'),
            SizedBox(height: 5.h),
            _buildPasswordField(provider),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller) => TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.hintText,
      filled: true,
      fillColor: AppColors.authTextFormFieldFillColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      prefixIcon: Padding(padding: EdgeInsets.only(left: 8.w), child: Icon(icon, color: AppColors.authBodyTextColor)),
    ),
  );

  Widget _buildPasswordField(RegisterProvider provider) => TextField(
    controller: _passwordController,
    obscureText: !provider.passwordVisible,
    decoration: InputDecoration(
      hintText: 'Enter your password',
      hintStyle: AppTextStyles.hintText,
      filled: true,
      fillColor: AppColors.authTextFormFieldFillColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      prefixIcon: const Icon(Icons.lock_outline_rounded),
      suffixIcon: IconButton(
        icon: Icon(provider.passwordVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: provider.togglePasswordVisibility,
      ),
    ),
  );

  Widget _label(String text) => Text(text, style: AppTextStyles.hintText);

  Widget _buildSignUpButton() => Consumer<RegisterProvider>(
    builder: (context, provider, child) {
      return AuthButton(
        text: Text('Sign Up'),
        onPressed: () async {
          final success = await provider.registerUser(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          // if (success) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(provider.errorMessage),
          //     ),
          //   );
          //   Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(provider.errorMessage),
          //     ),
          //   );
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage)));
          // }
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        provider.errorMessage,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.all(16),
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        provider.errorMessage,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }

        },
        color: AppColors.primaryColor,
      );
    },
  );

  Widget _buildOrJoinWithDivider() => Row(
    children: const [
      Expanded(child: Divider(color: AppColors.authTextFormFieldBorderColor)),
      Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('Or')),
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
            recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, RouteNames.loginScreen),
          ),
        ],
      ),
    ),
  );
}
