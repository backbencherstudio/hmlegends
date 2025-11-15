import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';

import '../../../../../../core/constant/asset_path.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../widget/show_send_invoice_bottom_sheet.dart';

class HeadOfficeInvoiceScreen extends StatelessWidget {
  final bool fromBottomNav;
  const HeadOfficeInvoiceScreen({super.key, required this.fromBottomNav});

  @override
  Widget build(BuildContext context) {
    final invoiceItems = [
      {
        "no": "01",
        "name": "Peri Chicken Wrap",
        "price": "£10",
        "qty": 10,
        "total": 100,
      },
      {
        "no": "02",
        "name": "Billy's Special",
        "price": "£12",
        "qty": 12,
        "total": 144,
      },
      {
        "no": "03",
        "name": "Chicken Steak & Chips",
        "price": "£8",
        "qty": 15,
        "total": 120,
      },
      {
        "no": "04",
        "name": "The Spicy Dip",
        "price": "£6.5",
        "qty": 16,
        "total": 104,
      },
      {
        "no": "05",
        "name": "Chicken Steak & Rice",
        "price": "£7.5",
        "qty": 16,
        "total": 120,
      },
    ];

    const subtotal = 588;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Invoice",
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        useBottomNavBack: fromBottomNav,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== INVOICE FROM SECTION =====
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice From",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: AppColors.authHeaderTextColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "JHON DOE",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "1550 Silky Blue Road San Francisco California",
                      style: TextStyle(
                        color: AppColors.authBodyTextColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      "(123) 123456-789",
                      style: TextStyle(
                        color: AppColors.authBodyTextColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    Divider(height: 20.h, color: const Color(0xFFEAEAEA)),
                    Text(
                      "Ship to",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: AppColors.authHeaderTextColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "JHON DOE",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "1550 Silky Blue Road San Francisco California",
                      style: TextStyle(
                        color: AppColors.authBodyTextColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      "(123) 123456-789",
                      style: TextStyle(
                        color: AppColors.authBodyTextColor,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
        
              // ===== INVOICE DETAILS SECTION =====
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "DATE: 20 APRIL 2025",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.authBodyTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "INVOICE NO: FS618A",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.authBodyTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20.h, color: const Color(0xFFEAEAEA)),
        
                    // ===== TABLE HEADER =====
        
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("NO", style: _headerText()),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text("Product Name", style: _headerText()),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Price",
                              style: _headerText(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Qty",
                              style: _headerText(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Total",
                              style: _headerText(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 12.h, color: const Color(0xFFEAEAEA)),
        
                    // ===== TABLE ITEMS =====
                    ...invoiceItems.map((item) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${item["no"]}",
                                    style: _bodyText(),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    "${item["name"]}",
                                    style: _bodyText(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${item["price"]}",
                                    style: _bodyText(),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${item["qty"]}",
                                    style: _bodyText(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${item["total"]}",
                                    style: _bodyText(),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Divider(height: 1.h, color: const Color(0xFFEAEAEA)),
                          ],
                        ),
                      );
                    }).toList(),
        
                    // ===== SUBTOTAL =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Subtotal: ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "£$subtotal",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: 24.h),
        
              // ===== FOOTER MESSAGE =====
              Text(
                "Branch name's invoice is ready. Now you can send/export it.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.authBodyTextColor,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
        
              // ===== ACTION BUTTONS =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Send Invoice
                  GestureDetector(
                    onTap: () => showSendInvoiceBottomSheet(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 12.h,
                      ),
                      child: Text(
                        "Send Invoice",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 28.w),
                  // Export PDF
                  Row(
                    children: [
                      //const Icon(Icons.picture_as_pdf, color: Colors.red),
                      Image.asset(AssetPaths.pdfIcon, height: 40.h, width: 40.w),
                      SizedBox(width: 8.w),
                      Text(
                        "Export pdf",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _headerText() => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13.sp,
    color: AppColors.authHeaderTextColor,
  );

  TextStyle _bodyText() => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.sp,
    color: AppColors.authBodyTextColor,
  );
}
