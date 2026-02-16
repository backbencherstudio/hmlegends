import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BranchList extends StatelessWidget {
  const BranchList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        "image": "assets/images/user1.png",
        "name": "Branch 1",
        "isActive": false,
        "location": "2118 Thornridge Cir. Syracuse, Connecticut 35624",
      },
      {
        "image": "assets/images/user2.png",
        "name": "Branch 2",
        "isActive": true,

        "location": "1901 Thornridge Cir. Shiloh, Hawaii 81063",
      },
      {
        "image": "assets/images/user3.png",
        "name": "Branch 3",
        "isActive": false,

        "location": "1901 Thornridge Cir. Shiloh, Hawaii 81063",
      },
      {
        "image": "assets/images/user1.png",
        "name": "Branch 4",
        "isActive": true,

        "location": "1901 Thornridge Cir. Shiloh, Hawaii 81063",
      },
    ];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final items = data[index];
        return Padding(
          padding: EdgeInsets.all(8.0),
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
                    // Circular branch image
                    ClipOval(
                      child: Image.asset(
                        items['image'] ?? "",
                        height: 80.h,
                        width: 80.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Branch name and location
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Branch name
                          Row(
                            children: [
                              Text(
                                items['name'] ?? "N/A",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xffDEF0DC),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  items['isActive'] ?? "N/A"
                                      ? "Active"
                                      : "Locked",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(0xff5BB450),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),

                          // Location row with icon
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
                                  items['location'] ?? "N/A",
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
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffFCE6E7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.file_present_rounded,
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffFCE6E7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit, color: Colors.red),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffFCE6E7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_person_outlined,
                        color: Colors.red,
                      ),
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
}
