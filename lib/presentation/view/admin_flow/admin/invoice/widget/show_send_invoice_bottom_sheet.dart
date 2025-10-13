import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';

void showSendInvoiceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white, // ✅ full white background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      final TextEditingController emailController = TextEditingController();

      return Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
          top: 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(height: 10.h),

            // === Title ===
            Text(
              "Type the email of the recipient.",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.authHeaderTextColor,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20.h),

            // === Email Input Field ===
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "branch01@gmail.com",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
            ),

            SizedBox(height: 25.h),

            // === Send Button ===
            AuthButton(
              text: 'Send',
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Invoice sent to $email"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              color: AppColors.primaryColor,
            ),

            SizedBox(height: 20.h),
          ],
        ),
      );
    },
  );
}
