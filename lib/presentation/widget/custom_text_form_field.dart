import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customTextFormField({
  String? labelText,
  required String hintText,
  required TextEditingController controller,
  Widget? suffixIcon,
  Widget? prefixIcon,
  required String? Function(String?)? validator,
  TextInputAction? textInputAction,
  bool isPassword = false,
}) {
  return TextFormField(
    controller: controller,
    textInputAction: textInputAction,
    obscureText: isPassword,
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
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Color(0xFFE9E9EA)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Color(0xFFE9E9EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Color(0xFFE9E9EA)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    ),
    validator: validator,
  );
}
