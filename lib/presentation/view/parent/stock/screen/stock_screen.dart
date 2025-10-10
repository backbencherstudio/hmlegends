// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hmlegends/core/constant/app_colors.dart';
// import 'package:hmlegends/core/constant/app_text_styles.dart';
// import 'package:hmlegends/core/constant/asset_path.dart';
// import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../domain/entities/product_entity.dart';
// import '../../../../view_model/parent/stock_viewmodel.dart';
//
// class StockScreen extends StatelessWidget {
//   const StockScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<StockViewModel>();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBarTwo(
//         title: 'Stock Management',
//         profileImage: AssetPaths.personIcon,
//         notificationCount: 4,
//         colorMain: Colors.white,
//         colorSpace: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           children: [
//             // Filter Buttons with Horizontal Scroll
//             SizedBox(
//               height: 36.h,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   _filterButton(context, vm, "All Products"),
//                   SizedBox(width: 8.w),
//                   _filterButton(context, vm, "In Stock"),
//                   SizedBox(width: 8.w),
//                   _filterButton(context, vm, "Stock Low"),
//                   SizedBox(width: 8.w),
//                   _filterButton(context, vm, "Out of Stock"),
//                 ],
//               ),
//             ),
//             SizedBox(height: 15.h),
//
//             // Search Field
//             Container(
//               height: 48.h,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30.r),
//                   color: AppColors.searchFieldBgColor
//               ),
//               child: TextField(
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(left: 60.w, right: 16.w, top: 14.h, bottom: 14.h),
//                   prefixIcon: Padding(
//                     padding: EdgeInsets.only(left: 12.w, right: 4.w),
//                     child: Icon(CupertinoIcons.search, color: AppColors.iconColor, size: 24.sp),
//                   ),
//                   prefixIconConstraints: BoxConstraints(
//                     minWidth: 44.w,
//                     minHeight: 48.h,
//                   ),
//                   hintText: 'Search',
//                   hintStyle: AppTextStyles.hintText,
//                   border: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                 ),
//               ),
//             ),
//             SizedBox(height: 12.h),
//
//             // Row with text and check icon + text
//             // Here filter button text
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'All Stock Products',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Image.asset(AssetPaths.addIcon,height: 20.h,width: 20.w,),
//                     SizedBox(width: 4.w),
//                     Text(
//                       'Add New',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: AppColors.headOfficeRadiusColor,
//                         fontWeight: FontWeight.w500
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 6.h),
//
//             // Product List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: vm.products.length,
//                 itemBuilder: (context, index) {
//                   final product = vm.products[index];
//                   // Assign images based on index or product ID
//                   final productImage = _getProductImage(index);
//                   return _productCard(product, productImage);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getProductImage(int index) {
//     final images = [
//       AssetPaths.stockImageOne,
//       AssetPaths.stockImageTwo,
//       AssetPaths.stockImageThree,
//     ];
//     return images[index % images.length];
//   }
//
//   Widget _filterButton(BuildContext context, StockViewModel vm, String title) {
//     final selected = vm.selectedFilter == title;
//     return GestureDetector(
//       onTap: () => vm.updateFilter(title),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
//         decoration: BoxDecoration(
//           color: AppColors.stockFilterButton,
//           borderRadius: BorderRadius.circular(30.r),
//         ),
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: selected ? AppColors.headOfficeRadiusColor : AppColors.authHeaderTextColor,
//             fontWeight: FontWeight.w500,
//             fontSize: 14.sp,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _productCard(ProductEntity product, String imagePath) {
//     Color statusColor;
//     switch (product.status) {
//       case "In Stock":
//         statusColor = Color(0xFFDEF0DC);
//         break;
//       case "Out of Stock":
//         statusColor = Color(0xFFFBD8DB);
//         break;
//       default:
//         statusColor = Color(0xFFFEF4CF);
//     }
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8.h),
//       padding: EdgeInsets.all(14.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.r)],
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10.r),
//             child: Image.asset(
//               imagePath,
//               width: 70.w,
//               height: 70.h,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   width: 70.w,
//                   height: 70.h,
//                   color: Colors.grey.shade300,
//                   child: Icon(Icons.image, color: Colors.grey, size: 24.sp),
//                 );
//               },
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.name,
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15.sp
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   "Stock: ${product.stock} pcs",
//                   style: TextStyle(fontSize: 12.sp),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   "£${product.price}",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15.sp
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//             decoration: BoxDecoration(
//                 color: statusColor,
//                 borderRadius: BorderRadius.circular(20.r)
//             ),
//             child: Text(
//               product.status,
//               style: TextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w600
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/entities/product_entity.dart';
import '../../../../view_model/parent/stock_viewmodel.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StockViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarTwo(
        title: 'Stock Management',
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: Colors.white,
        colorSpace: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Filter Buttons with Horizontal Scroll
            SizedBox(
              height: 36.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _filterButton(context, vm, "All Products"),
                  SizedBox(width: 8.w),
                  _filterButton(context, vm, "In Stock"),
                  SizedBox(width: 8.w),
                  _filterButton(context, vm, "Stock Low"),
                  SizedBox(width: 8.w),
                  _filterButton(context, vm, "Out of Stock"),
                ],
              ),
            ),
            SizedBox(height: 15.h),

            // Search Field
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: AppColors.searchFieldBgColor
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 60.w, right: 16.w, top: 14.h, bottom: 14.h),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 4.w),
                    child: Icon(CupertinoIcons.search, color: AppColors.iconColor, size: 24.sp),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 44.w,
                    minHeight: 48.h,
                  ),
                  hintText: 'Search',
                  hintStyle: AppTextStyles.hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Row with text and check icon + text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getFilterDisplayText(vm.selectedFilter),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.authHeaderTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(AssetPaths.addIcon,height: 20.h,width: 20.w,),
                    SizedBox(width: 4.w),
                    Text(
                      'Add New',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.headOfficeRadiusColor,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6.h),

            // Product List
            Expanded(
              child: ListView.builder(
                itemCount: vm.products.length,
                itemBuilder: (context, index) {
                  final product = vm.products[index];
                  // Assign images based on index or product ID
                  final productImage = _getProductImage(index);
                  return _productCard(product, productImage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to get display text based on selected filter
  String _getFilterDisplayText(String selectedFilter) {
    switch (selectedFilter) {
      case "In Stock":
        return "In Stock Products";
      case "Stock Low":
        return "Low Stock Products";
      case "Out of Stock":
        return "Out of Stock Products";
      default:
        return "All Stock Products";
    }
  }

  String _getProductImage(int index) {
    final images = [
      AssetPaths.stockImageOne,
      AssetPaths.stockImageTwo,
      AssetPaths.stockImageThree,
    ];
    return images[index % images.length];
  }

  Widget _filterButton(BuildContext context, StockViewModel vm, String title) {
    final selected = vm.selectedFilter == title;
    return GestureDetector(
      onTap: () => vm.updateFilter(title),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected? AppColors.stockFilterButton:Color(0xFFF1F0EE),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? AppColors.headOfficeRadiusColor : AppColors.authHeaderTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _productCard(ProductEntity product, String imagePath) {
    // Status text color and dot color
    Color statusColor;
    Color dotColor;
    switch (product.status) {
      case "In Stock":
        statusColor = AppColors.inStockTextColor;
        dotColor = AppColors.inStockTextColor;
        break;
      case "Out of Stock":
        statusColor = AppColors.outOfStockTextColor;
        dotColor = AppColors.outOfStockTextColor;
        break;
      default:
        statusColor = AppColors.inStockTextColor;
        dotColor = AppColors.inStockTextColor;
    }

    // Status background color
    Color statusBgColor;
    switch (product.status) {
      case "In Stock":
        statusBgColor = Color(0xFFDEF0DC);
        break;
      case "Out of Stock":
        statusBgColor = Color(0xFFFBD8DB);
        break;
      default:
        statusBgColor = Color(0xFFFEF4CF);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.r)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              imagePath,
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80.w,
                  height: 80.h,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.image, color: Colors.grey, size: 24.sp),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                      color: AppColors.authHeaderTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Stock: ${product.stock} pcs",
                  style: TextStyle(
                    color: AppColors.authHeaderTextColor,
                      fontSize: 13.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  "£${product.price}",
                  style: TextStyle(
                      color: AppColors.authHeaderTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Dot and text row with background color
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      product.status,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Edit and Delete icons
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle edit action
                      print('Edit ${product.name}');
                    },
                    child: Image.asset(
                      AssetPaths.editIcon,
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      // Handle delete action
                      print('Delete ${product.name}');
                    },
                    child: Image.asset(
                      AssetPaths.deleteIcon,
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}