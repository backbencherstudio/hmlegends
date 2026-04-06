import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/home/home_screen_provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/utlis/utils.dart';

class PendingUserList extends StatelessWidget {
  const PendingUserList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeScreenProvider>();
    final pendingData = homeProvider.pendingUserModel?.data?.users ?? [];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          "Pending Approvals",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
      ),
      body:
          pendingData.isEmpty
              ? const Center(child: Text("No Pending Approvals"))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: pendingData.length,
                itemBuilder: (context, index) {
                  final user = pendingData[index];

                  final bool isThisButtonLoading =
                      homeProvider.loadingUserId == user.id;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ------------- Name / Email / Type / Status ---------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? "No Name",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                user.email ?? "No Email",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Type: ${user.type ?? "N/A"}",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              SizedBox(height: 4.h),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Status: ",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: user.approvedBy ?? "N/A",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 10.w),

                        /// ----------- Accept / Reject Button ----------------
                        Column(
                          children: [
                            SizedBox(
                              width: 90.w,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed:
                                    isThisButtonLoading
                                        ? null
                                        : () async {
                                          await homeProvider.acceptRequest(
                                            user.id ?? "",
                                            "APPROVED",
                                          );

                                          Utils.showToast(
                                            msg: '${user.name} approved}',
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                          );
                                        },
                                child:
                                    isThisButtonLoading
                                        ? SizedBox(
                                          height: 18.h,
                                          width: 18.w,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                        )
                                        : Text(
                                          "Accept",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              width: 90.w,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed:
                                    isThisButtonLoading
                                        ? null
                                        : () async {
                                          await homeProvider.acceptRequest(
                                            user.id ?? "",
                                            "REJECTED",
                                          );

                                          if (!context.mounted) return;

                                          Utils.showToast(
                                            msg: '${user.name} rejected',
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                          );
                                        },
                                child: Text(
                                  "Reject",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
