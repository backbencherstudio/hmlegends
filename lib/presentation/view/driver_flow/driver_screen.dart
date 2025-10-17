import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../core/constant/asset_path.dart';
import '../widget/custom_app_bar.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // base design size (iPhone X style)
      builder: (context, child) {
        return Scaffold(
          appBar: CustomAppBar(
            profileImage: AssetPaths.personIcon,
            notificationCount: 4,
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0.w),
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return BranchInfoCard(
                      branchName: 'Branch Name-01',
                      address: '4140 Parker Rd. Allentown, New Mexico 31134',
                      totalProducts: 216,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BranchInfoCard extends StatelessWidget {
  final String branchName;
  final String address;
  final int totalProducts;

  const BranchInfoCard({
    super.key,
    required this.branchName,
    required this.address,
    required this.totalProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.driverBranseDetailScreen);
          },
          child: Container(
            width: double.infinity,
            height: 120.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6F7),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branch Name
                Text(
                  branchName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),

                // Address Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18.sp,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // Total Products
                RichText(
                  text: TextSpan(
                    text: 'Total Products: ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: totalProducts.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
