import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constant/asset_path.dart';
import '../../widget/simple_appbar.dart';

class OrdersScreen extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onPrefixTap;

  const OrdersScreen({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onSuffixTap,
    this.onPrefixTap,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppbar(
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(

                  hintText: widget.hintText,
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  prefixIcon: GestureDetector(
                    onTap: widget.onPrefixTap,
                    child: Icon(Icons.search,
                        color: Colors.grey.shade600, size: 22.w),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: widget.onSuffixTap,
                    child: Icon(Icons.tune,
                        color: Colors.grey.shade600, size: 22.w),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(spacing: 8.w,
                  children: [
                    Image.asset('assets/images/food_burger.png'),
                    SizedBox(
                      height: 50.h,
                      child: Column(
                        children: [
                          Row(spacing: 25.w,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Peri Chicken Wrap',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                  Text('Stock: 120 pcs',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                ],
                              ),
                              Container(
                                width: 76.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade100,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 5,
                                  children: [
                                    Container(width: 11.w,
                                      height: 11.h,
                                      decoration: BoxDecoration(
                                        color: Color(0xff5BB450),
                                        borderRadius: BorderRadius.circular(30.r),
                                      ),
                                    ),
                                    Text('In Stock',style: TextStyle(color: Color(0xff5BB450),fontWeight: FontWeight.w500,fontSize: 13.sp),),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(spacing: 10,
                            children: [
                              Container(
                                decoration: BoxDecoration(

                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
