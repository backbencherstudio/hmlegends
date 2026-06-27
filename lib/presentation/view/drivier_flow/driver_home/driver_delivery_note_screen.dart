import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:signature/signature.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';

class DriverDeliveryNoteScreen extends StatefulWidget {
  const DriverDeliveryNoteScreen({super.key});

  @override
  State<DriverDeliveryNoteScreen> createState() =>
      _DriverDeliveryNoteScreenState();
}

class _DriverDeliveryNoteScreenState extends State<DriverDeliveryNoteScreen> {
  late final SignatureController _signatureController;
  bool _hasSignature = false;

  void _showSuccessDialogAndNavigate(Map<String, dynamic>? args) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer faint circle
                    Container(
                      width: 100.r,
                      height: 100.r,
                      decoration: const BoxDecoration(
                        color: Color(0x1AED5E68), // 10% opacity
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Inner red circle
                    Container(
                      width: 60.r,
                      height: 60.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFED5E68),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.verified_outlined, color: Colors.white, size: 36.sp),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  "You have successfully\nconfirmed the delivery!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.pushReplacementNamed(
          context,
          RouteNames.deliverySummeryScreen,
          arguments: args,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black87,
      exportBackgroundColor: Colors.white,
    );
    
    _signatureController.onDrawEnd = () {
      if (!_hasSignature && _signatureController.isNotEmpty) {
        setState(() {
          _hasSignature = true;
        });
      }
    };
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = args?["name"] ?? "Branch Name-01";
    final address =
        args?["address"] ?? "4140 Parker Rd. Allentown, New Mexico 31134";
    final productsCount = args?["products"] ?? "216";

    return Scaffold(
      appBar: const CustomAppBar(notificationCount: 0, backArrow: "true"),
      body: Column(
        children: [
          // Header Container (White background)
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  address,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Products:   ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      productsCount,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main form area
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFDECEE), Color(0xFFF6B7B7)],
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Notes
                    Text(
                      "Delivery Notes (Optional)",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Add any special notes about the delivery.",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black45,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Signature Title
                    Row(
                      children: [
                        Icon(Icons.edit_document,
                            color: Colors.black87, size: 22.sp),
                        SizedBox(width: 8.w),
                        Text(
                          "Branch Manager Signature",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Please ask the branch manager to sign below to confirm delivery.",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Signature Pad
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.5,
                              // Simple solid border as fallback
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Signature(
                              controller: _signatureController,
                              height: 160.h,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        // "Sign here" placeholder if empty
                        if (!_hasSignature)
                          Positioned.fill(
                            child: Center(
                              child: IgnorePointer(
                                child: Text(
                                  "Sign here",
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Signature is required to complete delivery",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.undo, color: Colors.black54, size: 20.sp),
                              onPressed: () {
                                _signatureController.undo();
                                if (_signatureController.isEmpty) {
                                  setState(() => _hasSignature = false);
                                }
                              },
                            ),
                            SizedBox(width: 12.w),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.redo, color: Colors.black54, size: 20.sp),
                              onPressed: () {
                                _signatureController.redo();
                                if (_signatureController.isNotEmpty) {
                                  setState(() => _hasSignature = true);
                                }
                              },
                            ),
                            SizedBox(width: 12.w),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.clear, color: Colors.redAccent, size: 20.sp),
                              onPressed: () {
                                _signatureController.clear();
                                setState(() => _hasSignature = false);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),

                    // Bottom Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: const Color(0xFFED5E68), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFED5E68),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _hasSignature
                                ? () {
                                    _showSuccessDialogAndNavigate(args);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFED5E68),
                              disabledBackgroundColor: Colors.grey.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              elevation: 0,
                            ),
                            child: Text(
                              "Confirm Delivery",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
