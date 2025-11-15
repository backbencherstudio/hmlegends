// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../../core/constant/app_colors.dart';
// import '../../../../../../core/constant/asset_path.dart';
// import '../../../../widget/custom_app_bar.dart';
// import '../../../../widget/custom_app_bar_2.dart';
//
// class ManageDeliveryScreen extends StatelessWidget {
//   const ManageDeliveryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> branches = [
//       {
//         "name": "Branch Name-01",
//         "products": 200,
//         "address": "4517 Washington Ave. Manchester, Kentucky 39495",
//       },
//       {
//         "name": "Branch Name-01",
//         "products": 252,
//         "address": "2972 Westheimer Rd. Santa Ana, Illinois 85486",
//       },
//       {
//         "name": "Branch Name-02",
//         "products": 235,
//         "address": "2118 Thornridge Cir. Syracuse, Connecticut 35624",
//       },
//       {
//         "name": "Branch Name-03",
//         "products": 262,
//         "address": "7720 Birchwood Ave. Houston, Texas 77036",
//       },
//     ];
//
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: CustomAppBarTwo(
//         title: 'Manage Delivery',
//         profileImage: AssetPaths.personIcon,
//         notificationCount: 4, colorMain: Colors.white,colorSpace: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         child: Column(
//           children: branches.map((branch) {
//             return _BranchCard(
//               name: branch["name"],
//               totalProducts: branch["products"],
//               address: branch["address"],
//               onAssignTap: () {
//                 _showAssignModal(context, branch);
//               },
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   void _showAssignModal(BuildContext context, Map<String, dynamic> branch) {
//     final List<Map<String, dynamic>> items = [
//       {"name": "Peri Chicken Wrap", "qty": 20},
//       {"name": "Nashville Loaded Fries", "qty": 22},
//       {"name": "Chicken Steak & Rice", "qty": 25},
//       {"name": "The Khamzat Krunch", "qty": 18},
//       {"name": "Charlie’s Special", "qty": 19},
//       {"name": "Chicken Steak & Chips", "qty": 28},
//       {"name": "The Tyson", "qty": 31},
//       {"name": "The CR7", "qty": 27},
//       {"name": "Billy’s Special", "qty": 35},
//       {"name": "The Spicy Dip", "qty": 24},
//     ];
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 20.w,
//             right: 20.w,
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             top: 15.h,
//           ),
//           child: StatefulBuilder(
//             builder: (context, setState) {
//               final selected = <String>{};
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 50.w,
//                       height: 4.h,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade400,
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   Text(
//                     "Driver’s Name",
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xff333333),
//                     ),
//                   ),
//                   SizedBox(height: 5.h),
//                   TextField(
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       hintText: "Cameron Williamson",
//                       hintStyle: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 15.sp,
//                       ),
//                       filled: true,
//                       fillColor: const Color(0xffF8F8F8),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Text(
//                     "Driver’s ID",
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xff333333),
//                     ),
//                   ),
//                   SizedBox(height: 5.h),
//                   TextField(
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       hintText: "CW051895",
//                       hintStyle: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 15.sp,
//                       ),
//                       filled: true,
//                       fillColor: const Color(0xffF8F8F8),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15.h),
//                   Text(
//                     "Total Products: ${items.length}",
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xff111111),
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Divider(thickness: 1, color: Colors.grey.shade300),
//                   SizedBox(
//                     height: 350.h,
//                     child: ListView.builder(
//                       itemCount: items.length,
//                       itemBuilder: (context, index) {
//                         final item = items[index];
//                         final isSelected = selected.contains(item['name']);
//                         return ListTile(
//                           dense: true,
//                           contentPadding: EdgeInsets.zero,
//                           leading: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 if (isSelected) {
//                                   selected.remove(item['name']);
//                                 } else {
//                                   selected.add(item['name']);
//                                 }
//                               });
//                             },
//                             child: Container(
//                               width: 24.w,
//                               height: 24.w,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: const Color(0xffE20613),
//                                   width: 1.8,
//                                 ),
//                                 color: isSelected
//                                     ? const Color(0xffE20613)
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(5.r),
//                               ),
//                               child: isSelected
//                                   ? const Icon(Icons.check,
//                                   size: 16, color: Colors.white)
//                                   : null,
//                             ),
//                           ),
//                           title: Text(
//                             item['name'],
//                             style: TextStyle(
//                               fontSize: 15.sp,
//                               color: const Color(0xff333333),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           trailing: Text(
//                             "(${item['qty']})",
//                             style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontSize: 15.sp,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   Divider(thickness: 1, color: Colors.grey.shade300),
//                   SizedBox(height: 10.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Color(0xffE20613)),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.r),
//                             ),
//                             padding: EdgeInsets.symmetric(vertical: 12.h),
//                           ),
//                           child: Text(
//                             "Cancel",
//                             style: TextStyle(
//                               color: const Color(0xffE20613),
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 15.w),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xffE20613),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.r),
//                             ),
//                             padding: EdgeInsets.symmetric(vertical: 12.h),
//                           ),
//                           child: Text(
//                             "Send",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15.h),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
// // 🔹 Branch Card Widget
// class _BranchCard extends StatelessWidget {
//   final String name;
//   final int totalProducts;
//   final String address;
//   final VoidCallback onAssignTap;
//
//   const _BranchCard({
//     required this.name,
//     required this.totalProducts,
//     required this.address,
//     required this.onAssignTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 15.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF3F4),
//         borderRadius: BorderRadius.circular(15.r),
//         border: Border.all(color: const Color(0xFFE9E9E9)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16.sp,
//                   color: const Color(0xff111111),
//                 ),
//               ),
//               Text(
//                 "Total Products: $totalProducts",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15.sp,
//                   color: const Color(0xff333333),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10.h),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(
//                 Icons.location_on_outlined,
//                 color: const Color(0xffE20613),
//                 size: 20.sp,
//               ),
//               SizedBox(width: 5.w),
//               Expanded(
//                 child: Text(
//                   address,
//                   style: TextStyle(
//                     color: const Color(0xff4A4C56),
//                     fontSize: 14.sp,
//                     height: 1.4,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 15.h),
//           SizedBox(
//             width: double.infinity,
//             height: 44.h,
//             child: ElevatedButton(
//               onPressed: onAssignTap,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xffE20613),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.r),
//                 ),
//               ),
//               child: Text(
//                 "Assign to Driver",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/parent/manage_delivery_viewmodel.dart';
import '../widget/assign_driver_sheet.dart';
import '../widget/branch_card.dart';

class ManageDeliveryScreen extends StatelessWidget {
  const ManageDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //  Dummy Data (will come from API later)
    final List<Map<String, dynamic>> branches = [
      {
        "name": "Branch Name-01",
        "products": 200,
        "address": "4517 Washington Ave. Manchester, Kentucky 39495"
      },
      {
        "name": "Branch Name-01",
        "products": 252,
        "address": "2972 Westheimer Rd. Santa Ana, Illinois 85486"
      },
      {
        "name": "Branch Name-02",
        "products": 235,
        "address": "2118 Thornridge Cir. Syracuse, Connecticut 35624"
      },
      {
        "name": "Branch Name-03",
        "products": 262,
        "address": "7720 Birchwood Ave. Houston, Texas 77036"
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBarTwo(
        title: 'Manage Delivery',
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        onBackTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Consumer<ManageDeliveryViewModel>(
          builder: (context, provider, _) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: branches.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final branch = branches[index];

              return BranchCard(
                name: branch['name'] as String,
                totalProducts: branch['products'] as int,
                address: branch['address'] as String,
                isDisabled: provider.isDisabled(index),
                onAssignTap: () {
                  // Open bottom sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                    builder: (_) => AssignDriverSheet(
                      onSend: () {
                        provider.disableBranch(index);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
