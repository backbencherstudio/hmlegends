import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../admin_flow/view_model/auth_api/forget_password_viewmodel.dart';
import '../../widget/auth_button.dart';

class OtpVerifyScreen extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();

  OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForgetPasswordProvider>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100.h),

                /// LOGO
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

                /// EMAIL DISPLAY
                Text(
                  'We sent a reset code to ${provider.email.isNotEmpty ? provider.email : "your email"}. '
                  '\nEnter the 6-digit code below.',
                  style: AppTextStyles.authBodyText,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20.h),

                /// OTP FIELD
                _buildOtpField(),

                SizedBox(height: 20.h),

                /// VERIFY BUTTON
                AuthButton(
                  text:
                      provider.isFPLoading
                          ? Center(
                            child: SpinKitSpinningLines(
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          )
                          : Text(
                            'Verify Code',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  color: AppColors.primaryColor,
                  onPressed: () async {
                    final enteredOtp = _otpController.text.trim();

                    if (enteredOtp.isEmpty) {
                      Utils.showToast(
                        msg: 'Please enter otp code',
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      return;
                    }

                    final res = await provider.otpVerify(
                      email: provider.email,
                      otp: enteredOtp,
                    );

                    if (res.success) {
                      Utils.showToast(
                        msg: res.message,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                      if (context.mounted) {
                        final args = ModalRoute.of(context)?.settings.arguments;
                        Navigator.pushNamed(
                          context,
                          RouteNames.setNewPasswordScreen,
                          arguments: args,
                        );
                      }
                    } else {
                      Utils.showToast(
                        msg: res.message,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                ),

                SizedBox(height: 12.h),

                _buildOtpResendLink(provider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// OTP FIELD
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
      onCompleted: (pin) => debugPrint("Completed OTP: $pin"),
    );
  }

  Widget _buildOtpResendLink(ForgetPasswordProvider provider) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Haven’t got the email yet? ',
              style: AppTextStyles.hintText,
            ),
            TextSpan(
              text: provider.isFPLoading ? 'Sending...' : 'Resend Email',
              style: TextStyle(
                color:
                    provider.isFPLoading ? Colors.grey : AppColors.primaryColor,
                letterSpacing: 0.2,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () async {
                      if (provider.isFPLoading) return;
                      final res = await provider.forgetPassword(
                        email: provider.email,
                      );
                      if (res.success) {
                        Utils.showToast(
                          msg: res.message,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      } else {
                        Utils.showToast(
                          msg: res.message,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
