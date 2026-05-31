import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabeledInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool isNumeric;
  final bool isMultiline;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isNumeric = false,
    this.isMultiline = false,
    this.validator,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller,
            maxLines: isMultiline ? 3 : 1,
            keyboardType: isNumeric ? TextInputType.phone : TextInputType.text,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: placeholder,
              filled: true,
              fillColor: Color(0xFFF6F6F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Color(0xFFD2D2D5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Color(0xFFD2D2D5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Color(0xFFD2D2D5)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Colors.redAccent),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}