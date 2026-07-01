import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:hmlegends/presentation/widget/custom_rich_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../widget/custom_text_form_field.dart';
import '../../../view_model/profile/change_pass_provider.dart';

class HeadOfficeChangePasswordScreen extends StatefulWidget {
  const HeadOfficeChangePasswordScreen({super.key});

  @override
  State<HeadOfficeChangePasswordScreen> createState() =>
      _HeadOfficeChangePasswordScreenState();
}

class _HeadOfficeChangePasswordScreenState
    extends State<HeadOfficeChangePasswordScreen> {
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();

    Future<void> submitForm() async {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          _isLoading = true;
        });
        
        try {
          final oldPassword = provider.currentPasswordController.text;
          final newPassword = provider.newPasswordController.text;

          var res = await provider.changePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
          );

        if (res) {
          Utils.showToast(
            msg: 'Password changed successfully',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          provider.currentPasswordController.clear();
          provider.newPasswordController.clear();
          provider.confirmPasswordController.clear();
          if (mounted) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        } else {
          Utils.showToast(
            msg: 'Failed to change password',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF111111),
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: const Color(0xFF111111),
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),

      // Body Section
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 25.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- Current Password ----------------------------
              customRichText(labelText: 'Current Password'),
              SizedBox(height: 8.h),
              customTextFormField(
                hintText: 'Enter your current password',
                controller: provider.currentPasswordController,
                isPassword: _obscureCurrentPassword,
                textInputAction: TextInputAction.next,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF4A4C56),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
                validator: passwordValidator,
              ),
              SizedBox(height: 20.h),

              /// ----------------- New Password -------------------------------
              customRichText(labelText: 'New Password'),
              SizedBox(height: 8.h),
              customTextFormField(
                hintText: 'Enter your new password',
                controller: provider.newPasswordController,
                isPassword: _obscureNewPassword,
                textInputAction: TextInputAction.next,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF4A4C56),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                validator: passwordValidator,
              ),
              SizedBox(height: 20.h),

              /// ------------------- Confirm Password -------------------------
              customRichText(labelText: 'Confirm Password'),
              SizedBox(height: 8.h),
              customTextFormField(
                hintText: 'Confirm your new password',
                controller: provider.confirmPasswordController,
                isPassword: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF4A4C56),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != provider.newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.h),

              ///--------------------- Submit Button ---------------------------
              AuthButton(
                text: _isLoading
                    ? SpinKitSpinningLines(
                        color: Colors.white,
                        size: 24.sp,
                      )
                    : Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                onPressed: _isLoading ? () {} : submitForm,
                color: Color(0xffE20613),
              ),
              SizedBox(height: 10.h),

              /// ---------------- Forgot Password -----------------------------
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.forgetPasswordScreen,
                    arguments: {'fromChangePassword': true},
                  );
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: const Color(0xffE20613),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
