import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:signature/signature.dart';

import '../../widget/custom_app_bar.dart';

class ConfirmDeliveryScreen extends StatelessWidget {
  const ConfirmDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        notificationCount: 12,
        profileImage: "assets/images/wahab.png",
        backArrow: "back_arrow",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Branch Card
              Center(
                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(color: const Color(0xffFFFFFF)),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      Text(
                        "Branch Name-01",
                        style: TextStyle(
                          color: const Color(0xff1D1F2C),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "4140 Parker Rd. Allentown, New Mexico 31134",
                        style: TextStyle(
                          color: const Color(0xff4A4C56),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: const Color(0xff4A4C56),
                            fontSize: 14.sp,
                          ),
                          children: [
                            TextSpan(
                              text: "Total Products: ",
                              style: TextStyle(
                                color: const Color(0xff4A4C56),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: "8",
                              style: TextStyle(
                                color: const Color(0xff1D1F2C),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Notes + Signature Section
              SizedBox(
                width: double.infinity,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF6F7),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xffFFE0E3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Text(
                        "Delivery Notes (Optional)",
                        style: TextStyle(
                          color: const Color(0xff1D1F2C),
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Notes field
                      TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              "Add any special notes about the\n delivery.",
                          hintStyle: TextStyle(
                            color: const Color(0xff9A9DA7),
                            fontSize: 13.sp,
                          ),
                          filled: true,
                          fillColor: const Color(0xffFFFFFF),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xffD2D2D5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xffD2D2D5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xffD2D2D5),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // Signature label
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.edit_calendar,
                            color: Color(0xff4A4C56),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Branch Manager Signature",
                            style: TextStyle(
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        "Please ask the branch manager to sign below to confirm delivery.",
                        style: TextStyle(
                          color: const Color(0xff4A4C56),
                          fontSize: 12.sp,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Signature box
                      // Signature Section
                      const SizedBox(height: 20),
                      Text(
                        "Receiver’s Signature",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Signature(
                              controller: SignatureController(
                                penStrokeWidth: 3,
                                penColor: Colors.black,
                                exportBackgroundColor: Colors.white,
                              ),
                              height: 150,
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     ElevatedButton.icon(
                            //       onPressed: () {
                            //         // clear signature
                            //       },
                            //       icon: const Icon(Icons.clear, size: 16),
                            //       label: const Text("Clear"),
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: Colors.grey[300],
                            //         foregroundColor: Colors.black87,
                            //       ),
                            //     ),
                            //     ElevatedButton.icon(
                            //       onPressed: () async {
                            //         // Save or export the signature here
                            //       },
                            //       icon: const Icon(
                            //         Icons.save_alt_rounded,
                            //         size: 16,
                            //       ),
                            //       label: const Text("Save"),
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: const Color(0xFFEF4444),
                            //         foregroundColor: Colors.white,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),

                      SizedBox(height: 6.h),
                      Text("Signature is required to complete delivery"),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cancel Button
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xffE20613),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              // Cancel logic here
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Color(0xffE20613),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Confirm Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffE20613),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    contentPadding: const EdgeInsets.all(20),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          "assets/images/successful.png",
                                          height: 150,
                                          width: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          "You have successfully confirmed the delivery!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              RouteNames.deliverySummeryScreen,
                                            );
                                          },
                                          child: const Text(
                                            "OK",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },

                            child: const Text(
                              "Confirm Delivery",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
