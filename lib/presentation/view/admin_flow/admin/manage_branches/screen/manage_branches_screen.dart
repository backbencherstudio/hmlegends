import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../../widget/custom_app_bar_2.dart';

class ManageBranchesScreen extends StatelessWidget {
  const ManageBranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final branches = [
      {
        "name": "Branch Name/ID",
        "address": "2118 Thornridge Cir. Syracuse, Connecticut 35624",
        "status": "Active",
        "image": AssetPaths.personIcon1,
      },
      {
        "name": "Branch Name/ID",
        "address": "1901 Thornridge Cir. Shiloh, Hawaii 81063",
        "status": "Locked",
        "image": AssetPaths.personIcon1,
      },
      {
        "name": "Branch Name/ID",
        "address": "118 Thornridge Cir. Denver, Colorado 35624",
        "status": "Active",
        "image": AssetPaths.personIcon1,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: CustomAppBarTwo(
        title: "Manage Branches",
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Search Bar ===
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.searchFieldBgColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  const Icon(Icons.search, color: Colors.grey,),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(right: 10.w),
                  //   padding: EdgeInsets.all(8.w),
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFF5F5F5),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: const Icon(CupertinoIcons.slider_horizontal_3,
                  //       size: 20, color: Colors.black54),
                  // ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            // === Header Row ===
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r)
              ),
              child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 14.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Manage Branches",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.authHeaderTextColor,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, RouteNames.addNewBranchesScreen);
                      },
                      child: Row(
                        children: [
                          Image.asset(AssetPaths.addIcon,height: 20.h,width: 20.w,),
                          SizedBox(width: 6.w),
                          Text(
                            "Add New Branch",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
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

            // === Summary Cards ===
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    "08",
                    "Total\n Branches",
                    isHighlighted: true,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildSummaryCard("04", "Active\n Branches"),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildSummaryCard("07", "Locked\n Branches"),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // === Branch List ===
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];
                return _buildBranchCard(branch,context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Summary Card Widget
  Widget _buildSummaryCard(String value, String title,
      {bool isHighlighted = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isHighlighted ? Colors.red : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: AppColors.authHeaderTextColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.authBodyTextColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Branch Card Widget
  Widget _buildBranchCard(Map<String, dynamic> branch,BuildContext context) {
    final isActive = branch["status"] == "Active";

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Top Row (Image + Info + Status)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, RouteNames.manageBranchesToOrderSummaryScreen);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    branch["image"],
                    height: 65.h,
                    width: 65.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColors.authHeaderTextColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Image.asset(AssetPaths.locationIcon,
                            height: 22.h,width: 22.w,),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            branch["address"],
                            style: TextStyle(
                              color: AppColors.authBodyTextColor,
                              fontSize: 12.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F5E6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  branch["status"],
                  style: TextStyle(
                    color:  Color(0xFF5BB450),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // === Bottom Row (Action Icons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionIcon(AssetPaths.mbi1),
              InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, RouteNames.editBranchScreen);
                  },
                  child: _actionIcon(AssetPaths.mbi2)),

              _actionIcon(
                //isActive ? AssetPaths.mbi3 :AssetPaths.mbi3i,
              AssetPaths.mbi3),
              // _actionIcon(AssetPaths.mbi4,),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(String image,) {
    return Container(
      height: 36.h,
      width: 36.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image.asset(image,),
    );
  }
}
