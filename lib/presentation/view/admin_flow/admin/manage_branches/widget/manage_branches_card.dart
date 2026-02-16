import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageBranchesCard extends StatelessWidget {
  const ManageBranchesCard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> data = [
      {"number": "08", "text": "Total Branches"},
      {"number": "15", "text": "Active Branches"},
      {"number": "03", "text": "Locked Branches"},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final value = data[index];
          return Padding(
            padding: EdgeInsets.all(4.0),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: index == 0 ? Colors.red : Colors.white
                )
              ),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    value['number'] ?? "",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      value['text'] ?? "",
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
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
