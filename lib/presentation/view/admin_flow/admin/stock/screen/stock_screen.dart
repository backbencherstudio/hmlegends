import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../admin_model/admin_product_model.dart';
import '../../../view_model/stock/stock_screen_provider.dart';

class StockScreen extends StatefulWidget {
  final bool fromBottomNav;
  const StockScreen({super.key, required this.fromBottomNav});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockScreenProvider>().getProduct();
    });
  }

  List<Data> filterProducts(List<Data> products, int index) {
    switch (index) {
      case 1:
        return products.where((p) => p.stockStatus == "IN_STOCK").toList();
      case 2:
        return products.where((p) => p.stockStatus == "LOW_STOCK").toList();
      case 3:
        return products.where((p) => p.stockStatus == "OUT_OF_STOCK").toList();
      default:
        return products;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockScreenProvider>(
      builder: (context, vm, child) {
        final products = vm.adminProductModel?.data ?? [];
        final filteredProducts = filterProducts(products, vm.selectIndex);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarTwo(
            title: 'Stock Management',
            profileImage: AssetPaths.personIcon,
            notificationCount: 4,
            colorMain: Colors.white,
            colorSpace: Colors.white,
            useBottomNavBack: widget.fromBottomNav,
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
            child: Column(
              children: [
                // Horizontal filter tabs
                SizedBox(
                  height: 45.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vm.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final isSelected = index == vm.selectIndex;
                      return GestureDetector(
                        onTap: () {
                          vm.toggleSelect(index);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 17.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              color: isSelected
                                  ? const Color(0xFFFCEBE9)
                                  : const Color(0xFFF1F0EE),
                            ),
                            child: Center(
                              child: Text(
                                vm.data![index],
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFFE20613)
                                      : const Color(0xFF4A4C56),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: vm.adminProductModel == null
                      ? const Center(child: CircularProgressIndicator())
                      : filteredProducts.isEmpty
                      ? const Center(child: Text('No products found'))
                      : ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 6.h),
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 60.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: product.image != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                product.image!,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      color: product.image == null
                                          ? Colors.grey[300]
                                          : null,
                                    ),
                                    child: product.image == null
                                        ? const Icon(Icons.image, size: 30)
                                        : null,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name ?? "N/A",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "Price: \$${product.price ?? '0'}",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          product.stockStatus ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                product.stockStatus ==
                                                    "IN_STOCK"
                                                ? Colors.green
                                                : product.stockStatus ==
                                                      "LOW_STOCK"
                                                ? Colors.orange
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
