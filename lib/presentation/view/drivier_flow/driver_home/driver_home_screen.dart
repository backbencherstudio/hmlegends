import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';

import 'widgets/driver_branch_card.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final List<Map<String, dynamic>> _dummyData = [
    {
      "name": "Branch Name-01",
      "address": "4140 Parker Rd. Allentown, New Mexico 31134",
      "products": "216"
    },
    {
      "name": "Branch Name-02",
      "address": "4517 Washington Ave. Manchester, Kentucky 39495",
      "products": "250"
    },
    {
      "name": "Branch Name-03",
      "address": "2118 Thornridge Cir. Syracuse, Connecticut 35624",
      "products": "320"
    },
    {
      "name": "Branch Name-03",
      "address": "3517 W. Gray St. Utica, Pennsylvania 57867",
      "products": "200"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(notificationCount: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDECEE), 
              Color(0xFFF6B7B7),
            ],
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: _dummyData.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final item = _dummyData[index];
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.driverBranseDetailScreen,
                  arguments: item,
                );
              },
              child: BranchCard(
                name: item["name"],
                address: item["address"],
                products: item["products"],
                backgroundColor: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

