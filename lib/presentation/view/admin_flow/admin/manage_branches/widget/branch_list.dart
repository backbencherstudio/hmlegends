import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../model/manage_branch_model.dart';

class BranchList extends StatelessWidget {
  final List<Managers> managers;

  const BranchList({super.key, required this.managers});

  @override
  Widget build(BuildContext context) {
    if (managers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No Branches Found"),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: managers.length,
      itemBuilder: (context, index) {
        final items = managers[index];
        final bool isActive = items.status == "ACTIVE";

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(9.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.grey.shade200,
                        image:
                            items.avatar != null
                                ? DecorationImage(
                                  image: NetworkImage(items.avatar!),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          items.avatar == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  items.name ?? "N/A",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isActive
                                          ? const Color(0xffDEF0DC)
                                          : const Color(0xffFCE6E7),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Text(
                                  isActive ? "Active" : "Locked",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color:
                                        isActive
                                            ? const Color(0xff5BB450)
                                            : Colors.red,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 6.h),

                          /// Location Row (Exact same layout)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 18.sp,
                                color: Colors.black,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  items.address ?? "No address available",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15.h),

                /// 🔥 Bottom Action Buttons (Restored exactly)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugPrint("THe userIUD : ${items.id}");

                        Navigator.pushNamed(
                          context,
                          RouteNames.manageBranchesToOrderSummaryScreen,
                          arguments: items.id,
                        );
                      },
                      child: _actionButton(Icons.file_present_rounded),
                    ),
                    GestureDetector(
                      onTap: () {
                        debugPrint("THe userIUD : ${items.id}");
                        Navigator.pushNamed(
                          context,
                          RouteNames.editBranchScreen,
                          arguments: items.id,
                        );
                      },
                      child: _actionButton(Icons.edit),
                    ),
                    _actionButton(
                      isActive ? Icons.lock_open : Icons.lock_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xffFCE6E7),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.red),
    );
  }
}
