import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../admin_flow/view_model/profile/change_pass_provider.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void submitForm() {
      if (formKey.currentState?.validate() ?? false) {
        log('Password Change Request Sent!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
      }
    }

    Widget buildTextField({
      required String labelText,
      required String hintText,
      required TextEditingController controller,
      bool isPassword = false,
      bool showSuffixIcon = false,
      bool? isVisible,
      ValueChanged<bool>? toggleVisibility,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0.h),
            child: RichText(
              text: TextSpan(
                text: labelText,
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff2F2A29),
                ),
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            obscureText: isPassword ? !(isVisible ?? false) : false,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17.sp),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              filled: true,
              fillColor: Color(0xffF6F6F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0.r),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0.r),
                borderSide: const BorderSide(color: Color(0xffE20613), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0.r),
                borderSide: BorderSide(color: Colors.grey.shade400,width: 1.5),
              ),
              suffixIcon: (isPassword && showSuffixIcon)
                  ? IconButton(
                icon: Icon(
                  (isVisible ?? false)
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: 20.sp,
                ),
                onPressed: () {
                  if (toggleVisibility != null) {
                    toggleVisibility(!isVisible!);
                  }
                },
              )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (isPassword && value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          SizedBox(height: 25.0.h),
        ],
      );
    }
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20.sp,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  buildTextField(
                    labelText: 'Current Password',
                    hintText: 'Enter your current password',
                    isPassword: true,
                    showSuffixIcon: false,
                    controller: provider.currentPasswordController,
                  ),
                  buildTextField(
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
                    isPassword: true,
                    showSuffixIcon: true,
                    isVisible: provider.isNewPasswordVisible,
                    toggleVisibility: provider.toggleNewPasswordVisibility,
                    controller: provider.newPasswordController,
                  ),
                  buildTextField(
                    labelText: 'Confirm New Password',
                    hintText: 'Confirm your new password',
                    isPassword: true,
                    showSuffixIcon: true,
                    isVisible: provider.isConfirmPasswordVisible,
                    toggleVisibility: provider.toggleConfirmPasswordVisibility,
                    controller: provider.confirmPasswordController,
                  ),
                  SizedBox(height: 10.0.h),
                  SizedBox(
                    width: double.infinity,
                    height: 46.h,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffE20613),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0.r),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color(0xffE20613),
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}