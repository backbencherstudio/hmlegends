import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/app_text_styles.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../view_model/parent/stock_viewmodel.dart';
import '../widget/filter_button.dart';
import '../widget/product_card.dart';
import '../../widget/search_filter.dart';

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
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
        child: Column(
          children: [
            _buildFilterButtons(vm),
            SizedBox(height: 15.h),
            SearchField(),
            SizedBox(height: 12.h),
            _buildHeaderRow(vm),
            SizedBox(height: 6.h),
            _buildProductList(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButtons(StockViewModel vm) {
    final filters = ["All Products", "In Stock", "Stock Low", "Out of Stock"];

    return SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters
            .map(
              (filter) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FilterButton(
                  title: filter,
                  isSelected: vm.selectedFilter == filter,
                  onTap: () => vm.updateFilter(filter),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildHeaderRow(StockViewModel vm) {
    return Row(
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
            Image.asset(AssetPaths.addIcon, height: 20.h, width: 20.w),
            SizedBox(width: 4.w),
            Text(
              'Add New',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.headOfficeRadiusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductList(StockViewModel vm) {
    return Expanded(
      child: ListView.builder(
        itemCount: vm.products.length,
        itemBuilder: (context, index) {
          final product = vm.products[index];
          final productImage = _getProductImage(index);
          return ProductCard(product: product, imagePath: productImage);
        },
      ),
    );
  }

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
}


