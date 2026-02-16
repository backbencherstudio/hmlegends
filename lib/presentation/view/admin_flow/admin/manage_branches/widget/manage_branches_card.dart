import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageBranchesCard extends StatelessWidget {

  final int totalBranches;
  final int activeBranches;
  final int lockedBranches;

  const ManageBranchesCard({
    super.key,
    required this.totalBranches,
    required this.activeBranches,
    required this.lockedBranches,
  });

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> data = [
      {"number": totalBranches, "text": "Total Branches"},
      {"number": activeBranches, "text": "Active Branches"},
      {"number": lockedBranches, "text": "Locked Branches"},
    ];

    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {

          final value = data[index];

          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              width: 130.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: index == 0 ? Colors.red : Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    value['number'].toString(),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    value['text'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
