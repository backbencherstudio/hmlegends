import 'package:flutter/material.dart';
import '../../../widget/google_button.dart';

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
        GoogleButton(),

        // SizedBox(height: 10.h),
        // SignUpFormButton(
        //   title: 'Continue With Apple',
        //   image: AssetPaths.appleIcon,
        //   onTap: onApplePressed,
        // ),
      ],
    );
  }
}
