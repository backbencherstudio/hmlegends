import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';

import 'SignUpFormButton.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onApplePressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;

  const SocialAuthButtons({
    super.key,
    this.onApplePressed,
    this.onGooglePressed,
    this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignUpFormButton(
          title: 'Sign Up With Google',
          image: AssetPaths.googleIcon,
          onTap: onGooglePressed,
        ),

        SizedBox(height: 10.h),
        SignUpFormButton(
          title: 'Sign Up With Apple',
          image: AssetPaths.appleIcon,
          onTap: onApplePressed,
        ),
      ],
    );
  }
}
