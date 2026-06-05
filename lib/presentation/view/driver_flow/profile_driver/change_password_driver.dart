import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../admin_flow/view_model/profile/change_pass_provider.dart';

class HeadOfficeChangePasswordScreen extends StatelessWidget {
  const HeadOfficeChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void submitForm() {
      if (formKey.currentState?.validate() ?? false) {
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
          // Label
          RichText(
            text: TextSpan(
              text: labelText,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E1E1E), // dark charcoal
                letterSpacing: 0.2,
              ),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xffE20613)),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // Input Field
          TextFormField(
            controller: controller,
            obscureText: isPassword ? !(isVisible ?? false) : false,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF222222),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: const Color(0xffF8F8F8),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 15.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ), // Primary Red
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.3),
              ),
              suffixIcon: (isPassword && showSuffixIcon)
                  ? IconButton(
                      icon: Icon(
                        (isVisible ?? false)
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade600,
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
          SizedBox(height: 25.h),
        ],
      );
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

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 25.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fields
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

              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE20613),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Forgot Password
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
