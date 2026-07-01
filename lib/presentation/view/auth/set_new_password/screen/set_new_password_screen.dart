import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../admin_flow/view_model/auth/new_password_viewmodel.dart';
import '../../../admin_flow/view_model/auth_api/forget_password_viewmodel.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:hmlegends/presentation/view/auth/widget/level_text.dart';

class SetNewPasswordScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  SetNewPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Provider.of<ForgetPasswordProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  'Create a new password. Ensure it differs from previous ones for security.',
                  style: AppTextStyles.authBodyText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RequiredLabel(labelText: 'Password'),
                ),
                SizedBox(height: 5.h),
                _buildPasswordField(),

                SizedBox(height: 15.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: RequiredLabel(labelText: 'Confirm Password'),
                ),
                SizedBox(height: 5.h),
                _buildConfirmPasswordField(),

                SizedBox(height: 10.h),
                _buildErrorMessage(),

                SizedBox(height: 25.h),

                Consumer<ForgetPasswordProvider>(
                  builder: (context, provider, _) {
                    return AuthButton(
                      text: provider.isFPLoading
                          ? Center(
                              child: SpinKitSpinningLines(
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            )
                          : Text(
                              'Update Password',
                              style: TextStyle(color: Colors.white),
                            ),
                      color: AppColors.primaryColor,
                      onPressed: () async {
                            final password = _passwordController.text.trim();
                            final confirmPassword =
                                _confirmPasswordController.text.trim();

                            if (password != confirmPassword) {
                              Utils.showToast(
                                msg: "Passwords do not match.",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }

                            if (password.isEmpty) {
                              Utils.showToast(
                                msg: "Password cannot be empty.",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }

                            final success = await provider.setPassword(
                              password: password,
                            );

                            Utils.showToast(
                              msg: provider.errorMessage,
                              backgroundColor: success ? Colors.green : Colors.red,
                              textColor: Colors.white,
                            );

                            if (success && context.mounted) {
                              final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                              final fromChangePassword = args?['fromChangePassword'] ?? false;

                              if (fromChangePassword) {
                                Navigator.popUntil(
                                  context,
                                  (route) => route.settings.name == RouteNames.headOfficeChangePasswordScreen,
                                );
                              } else {
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteNames.loginScreen,
                                );
                              }
                            }
                          },
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

  /// ================= PASSWORD FIELD =================
  Widget _buildPasswordField() {
    return Consumer<SetNewPasswordViewModel>(
      builder: (context, viewModel, child) {
        return TextField(
          controller: _passwordController,
          obscureText: !viewModel.passwordVisible,
          onChanged: viewModel.setPassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Enter Your New Password',
            hintStyle: AppTextStyles.hintText,
            filled: true,
            fillColor: AppColors.authTextFormFieldFillColor,
            border: _outlineBorder(),
            focusedBorder: _outlineBorder(),
            enabledBorder: _outlineBorder(),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: viewModel.togglePasswordVisibility,
            ),
          ),
        );
      },
    );
  }

  /// ================= CONFIRM PASSWORD FIELD =================
  Widget _buildConfirmPasswordField() {
    return Consumer<SetNewPasswordViewModel>(
      builder: (context, viewModel, child) {
        return TextField(
          controller: _confirmPasswordController,
          obscureText: !viewModel.confirmPasswordVisible,
          textInputAction: TextInputAction.done,
          onChanged: viewModel.setConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Re-enter Your New Password',
            hintStyle: AppTextStyles.hintText,
            filled: true,
            fillColor: AppColors.authTextFormFieldFillColor,
            border: _outlineBorder(),
            focusedBorder: _outlineBorder(),
            enabledBorder: _outlineBorder(),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
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
        return viewModel.errorMessage != null &&
                viewModel.errorMessage!.isNotEmpty
            ? Text(
              viewModel.errorMessage!,
              style: const TextStyle(color: Colors.red),
            )
            : const SizedBox.shrink();
      },
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.r),
      borderSide: BorderSide(color: AppColors.authTextFormFieldBorderColor),
    );
  }
}
