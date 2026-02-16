import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/branch_list.dart';
import '../widget/custom_appbar.dart';
import '../widget/manage_branches_card.dart';

class ManageBranchesScreen extends StatelessWidget {
  const ManageBranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF6F7),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppbar(
                title: "Manage Branches",
                back: Icons.arrow_back_ios,
                img: "assets/images/wahab.png",
                notification: Icons.notification_add_rounded,
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEFEFEF),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xffFEECEE), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xffFEECEE), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xffFEECEE), width: 1),
                  ),
                  hint: Text("Search"),
                ),
              ),
          
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Manage Branches",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Add New Branch",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          
              SizedBox(height: 20.h),
              ManageBranchesCard(),
              BranchList(),
            ],
          ),
        ),
      ),
    );
  }
}
