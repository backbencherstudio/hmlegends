import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';

class RequiredLabel extends StatelessWidget {
  final String labelText;
  final TextStyle? labelStyle;

  const RequiredLabel({super.key, required this.labelText, this.labelStyle});

  @override
  Widget build(BuildContext context) {
    return Text(labelText, style: labelStyle ?? AppTextStyles.labelText);
  }
}
