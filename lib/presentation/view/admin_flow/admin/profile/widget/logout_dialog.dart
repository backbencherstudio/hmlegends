import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/core/services/token_storage.dart';
import 'package:hmlegends/core/services/user_type_storage.dart';

void logoutShowSubmitDialog(BuildContext context) {
  final TokenStorage token = TokenStorage();
  final UserTypeStorage userType = UserTypeStorage();

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Premium Branded Logout Icon Header
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: const Color(0xffE20613).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: const Color(0xffE20613),
                size: 28.sp,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Header Title
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2024),
              ),
            ),
            SizedBox(height: 8.h),
            
            // Subtitle Description
            Text(
              'Are you sure you want to log out?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF71727A),
              ),
            ),
            SizedBox(height: 24.h),
            
            // Action Buttons
            Row(
              children: [
                // Log me out (Outlined/Cancel Style)
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () async {
                        await token.clearToken();
                        await userType.clearUserType();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteNames.loginScreen,
                            (route) => false,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xffE20613), width: 1.5),
                        foregroundColor: const Color(0xffE20613),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Log me out',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                
                // Stay logged in (Filled/Confirm Style)
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE20613),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Stay logged in',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
