import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Filter types for branch display
enum BranchFilter { all, active, locked }

class ManageBranchesCard extends StatelessWidget {
  final int totalBranches;
  final int activeBranches;
  final int lockedBranches;
  final int selectedIndex;
  final Function(int) onCardTap;

  const ManageBranchesCard({
    super.key,
    required this.totalBranches,
    required this.activeBranches,
    required this.lockedBranches,
    required this.selectedIndex,
    required this.onCardTap,
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
            child: GestureDetector(
              onTap: () => onCardTap(index),
              child: Container(
                width: 130.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color:
                        selectedIndex == index
                            ? Colors.red
                            : Colors.transparent,
                    width: 2,
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
                        color:
                            selectedIndex == index ? Colors.red : Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      value['text'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color:
                            selectedIndex == index ? Colors.red : Colors.grey,
                        fontWeight:
                            selectedIndex == index
                                ? FontWeight.w600
                                : FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
