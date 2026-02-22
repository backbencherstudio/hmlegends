import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constant/asset_path.dart';


class BranchCard extends StatelessWidget {
  final String name;
  final int totalProducts;
  final String address;
  final VoidCallback onAssignTap;


  const BranchCard({
    super.key,
    required this.name,
    required this.totalProducts,
    required this.address,
    required this.onAssignTap,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F4),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: const Color(0xff111111))),
              Text(
                "Total Products: $totalProducts",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: const Color(0xff333333)),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(AssetPaths.locationIcon1, width: 24.w, height: 24.w),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(
                    color: const Color(0xff4A4C56),
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              onPressed:  onAssignTap,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      // When button is disabled
                      return const Color(0xFFEF6471);
                    }
                    // Default active color
                    return const Color(0xffE20613);
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
              ),
              child: Text(
                "Assign to Driver",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
