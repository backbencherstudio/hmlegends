import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/asset_path.dart';
import '../../../../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final String imagePath;

  const ProductCard({super.key, required this.product, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final statusColors = _getStatusColors(product.status);

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
          _buildProductImage(),
          SizedBox(width: 12.w),
          _buildProductDetails(),
          _buildStatusSection(statusColors),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Image.asset(
        imagePath,
        width: 80.w,
        height: 80.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 80.w, height: 80.h, color: Colors.grey.shade300,
          child: Icon(Icons.image, color: Colors.grey, size: 24.sp),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: TextStyle(color: AppColors.authHeaderTextColor, fontWeight: FontWeight.bold, fontSize: 15.sp)),
          SizedBox(height: 4.h),
          Text("Stock: ${product.stock} pcs", style: TextStyle(color: AppColors.authHeaderTextColor, fontSize: 13.sp)),
          SizedBox(height: 4.h),
          Text("£${product.price}", style: TextStyle(color: AppColors.authHeaderTextColor, fontWeight: FontWeight.w600, fontSize: 15.sp)),
        ],
      ),
    );
  }

  Widget _buildStatusSection(Map<String, Color> statusColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          decoration: BoxDecoration(color: statusColors['bg']!, borderRadius: BorderRadius.circular(20.r)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 6.w, height: 6.h, decoration: BoxDecoration(color: statusColors['dot']!, shape: BoxShape.circle)),
            SizedBox(width: 6.w),
            Text(product.status, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: statusColors['text']!)),
          ]),
        ),
        SizedBox(height: 12.h),
        Row(children: [
          _buildActionIcon(AssetPaths.editIcon, () => print('Edit ${product.name}')),
          SizedBox(width: 12.w),
          _buildActionIcon(AssetPaths.deleteIcon, () => print('Delete ${product.name}')),
        ]),
      ],
    );
  }

  Widget _buildActionIcon(String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(iconPath, width: 16.w, height: 16.h),
    );
  }

  Map<String, Color> _getStatusColors(String status) {
    switch (status) {
      case "In Stock": return {'text': AppColors.inStockTextColor, 'dot': AppColors.inStockTextColor, 'bg': Color(0xFFDEF0DC)};
      case "Out of Stock": return {'text': AppColors.outOfStockTextColor, 'dot': AppColors.outOfStockTextColor, 'bg': Color(0xFFFBD8DB)};
      default: return {'text': AppColors.inStockTextColor, 'dot': AppColors.inStockTextColor, 'bg': Color(0xFFFEF4CF)};
    }
  }
}