import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.hintText,
    required this.text,
    required this.onChanged,
  });

  final String hintText;
  final String text;
  final ValueChanged<String> onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.text;
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != controller.text) {
      controller.text = widget.text;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: AppColors.searchFieldBgColor,
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) => widget.onChanged(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 50.w,
            right: 16.w,
            top: 14.h,
            bottom: 14.h,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 4.w),
            child: Icon(
              CupertinoIcons.search,
              color: AppColors.iconColor,
              size: 24.sp,
            ),
          ),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            minWidth: 44.w,
            minHeight: 48.h,
          ),
          hintText:
              widget.hintText,
          hintStyle: AppTextStyles.hintText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
