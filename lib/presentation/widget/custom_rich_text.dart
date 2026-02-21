import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customRichText({required String labelText}) {
  return RichText(
    text: TextSpan(
      text: labelText,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E1E1E),
        letterSpacing: 0.2,
      ),
      children: const [
        TextSpan(text: ' *', style: TextStyle(color: Color(0xffE20613))),
      ],
    ),
  );
}
