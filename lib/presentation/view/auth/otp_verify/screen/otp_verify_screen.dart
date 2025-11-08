import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view_model/auth_api/verify_otp_viewmodel.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/route/route_names.dart';
import '../../widget/auth_button.dart';

class OtpVerifyScreen extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();

  OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerifyOtpViewmodel>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 100.h),
              Center(
                child: Image.asset(
                  AssetPaths.authLogo,
                  width: 100.w,
                  height: 100.h,
                ),
              ),
              SizedBox(height: 20.h),
              Text('Check Your Mail', style: AppTextStyles.authHeadline),
              SizedBox(height: 8.h),

              Text(
                'We sent a reset code to ${provider.email.isNotEmpty ? provider.email : "your email"}. '
                    'Enter the 6-digit code below.',
                style: AppTextStyles.authBodyText,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20.h),
              _buildOtpField(),
              SizedBox(height: 20.h),

              provider.isFPLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : _otpVerifyButton(context, provider),

              SizedBox(height: 10.h),
              _buildOtpResendLink(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField() {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 48.h,
      textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: AppColors.otpVerifyColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );

    return Pinput(
      length: 6,
      controller: _otpController,
      defaultPinTheme: defaultPinTheme,
      keyboardType: TextInputType.number,
      showCursor: true,
      onCompleted: (pin) {
        debugPrint("Completed OTP: $pin");
      },
    );
  }

  Widget _otpVerifyButton(BuildContext context, VerifyOtpViewmodel provider) {
    return AuthButton(
      text: 'Verify Code',
      color: AppColors.primaryColor,
      onPressed: () async {
        final enteredOtp = _otpController.text.trim();

        if (enteredOtp.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter the OTP")),
          );
          return;
        }

        final success = await provider.verifyOtp(enteredOtp);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: success ? Colors.green : Colors.red,
            content: Text(provider.errorMessage),
          ),
        );

        if (success && context.mounted) {
          Navigator.pushNamed(context, RouteNames.setNewPasswordScreen);
        }
      },
    );
  }

  Widget _buildOtpResendLink(VerifyOtpViewmodel provider) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Haven’t got the email yet? ',
              style: AppTextStyles.hintText,
            ),
            TextSpan(
              text: 'Resend Email',
              style: TextStyle(
                color: AppColors.primaryColor,
                letterSpacing: 0.2,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await provider.forgetPassword(email: provider.email);
                },
            ),
          ],
        ),
      ),
    );
  }
}
