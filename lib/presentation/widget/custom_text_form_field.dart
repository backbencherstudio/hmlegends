import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customTextFormField({
  String? labelText,
  required String hintText,
  required TextEditingController controller,
  Widget? suffixIcon,
  required String? Function(String?)? validator,
  TextInputAction? textInputAction,
  bool isPassword = false,
  bool showSuffixIcon = false,
  bool? isVisible,
  ValueChanged<bool>? toggleVisibility,
}) {
  return TextFormField(
    controller: controller,
    textInputAction: textInputAction,
    obscureText: isPassword ? !(isVisible ?? false) : false,
    decoration: InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: TextStyle(
        color: Color(0xFF4A4C56),
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: const Color(0xffF8F8F8),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Color(0xFF4A4C56)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Color(0xFF4A4C56)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Color(0xFF4A4C56)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      suffixIcon:
          (isPassword && showSuffixIcon)
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
    validator: validator,
  );
}
