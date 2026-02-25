import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:hmlegends/presentation/widget/custom_rich_text.dart';
import 'package:provider/provider.dart';
import '../../../../../widget/custom_text_form_field.dart';
import '../../../view_model/profile/change_pass_provider.dart';

class HeadOfficeChangePasswordScreen extends StatelessWidget {
  const HeadOfficeChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Future<void> submitForm() async {
      if (formKey.currentState?.validate() ?? false) {
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
        } else {
          Utils.showToast(
            msg: 'Failed to change password',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
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
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- Current Password ----------------------------
              customRichText(labelText: 'Current Password'),
              SizedBox(height: 8.h),
              customTextFormField(
                labelText: 'Current Password',
                hintText: 'Enter your current password',
                controller: provider.currentPasswordController,
                isPassword: true,
                validator: passwordValidator,
              ),
              SizedBox(height: 20.h),

              /// ----------------- New Password -------------------------------
              customRichText(labelText: 'New Password'),
              SizedBox(height: 8.h),
              customTextFormField(
                labelText: 'New Password',
                hintText: 'Enter your new password',
                isPassword: true,
                controller: provider.newPasswordController,
                validator: passwordValidator,
              ),
              SizedBox(height: 20.h),

              /// ------------------- Confirm Password -------------------------
              customRichText(labelText: 'Confirm Password'),
              SizedBox(height: 8.h),
              customTextFormField(
                labelText: 'Confirm New Password',
                hintText: 'Confirm your new password',
                isPassword: true,
                controller: provider.confirmPasswordController,
                validator: confirmPasswordValidator,
              ),

              SizedBox(height: 24.h),

              ///--------------------- Submit Button ---------------------------
              AuthButton(
                text: Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: submitForm,
                color: Color(0xffE20613),
              ),
              SizedBox(height: 10.h),

              /// ---------------- Forgot Password -----------------------------
              TextButton(
                onPressed: () {},
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
