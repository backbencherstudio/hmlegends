import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../widget/simple_appbar.dart';
import '../../data/get_all_products_model.dart';
import '../../data/create_order_model.dart';
import '../../viewmodel/create_order_viewmodel.dart';
import '../../viewmodel/get_all_product_viewmodel.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Map<String, int> _selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetProductsViewmodel>().fetchProducts();
    });
  }

  int get totalSelectedItems => _selectedQuantities.values.fold(0, (sum, qty) => sum + qty);

  @override
  Widget build(BuildContext context) {
    final orderVM = context.watch<OrderViewmodel>();

    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: const SimpleAppbar(
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        title: 'Place Order',
        navigationType: NavigationType.none,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Selected Items Summary
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4.r, offset: Offset(0, 2.h)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total items Selected: $totalSelectedItems',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  ElevatedButton(
                    onPressed: totalSelectedItems > 0 ? () => _showSubmitDialog(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: totalSelectedItems > 0 ? const Color(0xffE20613) : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    ),
                    child: Text('Submit Order', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Search Bar
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: const Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 22.w),
                  suffixIcon: Icon(Icons.tune, color: Colors.grey.shade600, size: 22.w),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Products List
            Expanded(
              child: Consumer<GetProductsViewmodel>(
                builder: (context, vm, child) {
                  if (vm.isLoading && vm.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (vm.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          SizedBox(height: 16.h),
                          Text(vm.errorMessage),
                          ElevatedButton(
                            onPressed: () => vm.fetchProducts(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }
                  if (vm.products.isEmpty) {
                    return const Center(child: Text("No products available"));
                  }

                  return ListView.builder(
                    itemCount: vm.products.length,
                    itemBuilder: (context, index) {
                      final product = vm.products[index];
                      final currentQty = _selectedQuantities[product.id] ?? 0;

                      return _buildProductCard(product, currentQty, (newQty) {
                        setState(() {
                          if (newQty > 0) {
                            _selectedQuantities[product.id] = newQty;
                            orderVM.addProduct(ProductSelectModel(
                              productId: product.id,
                              productQty: newQty,
                            ));
                          } else {
                            _selectedQuantities.remove(product.id);
                            orderVM.removeProduct(
                              product.id,
                            );
                          }
                        });
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      Products product,
      int quantity,
      Function(int) onQuantityChanged,
      ) {
    final isSelected = quantity > 0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                image: product.image ?? "",
                width: 92.w,
                height: 100.h,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 92.w,
                    height: 100.h,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.red),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        '৳${product.price.toStringAsFixed(0)} • Stock: ${product.stock}',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: product.stockStatus == 'IN_STOCK'
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Text(
                          product.stockStatus == 'IN_STOCK' ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color: product.stockStatus == 'IN_STOCK' ? Colors.green : Colors.red,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        width: 100.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: quantity > 0 ? () => onQuantityChanged(quantity - 1) : null,
                              icon: Icon(Icons.remove, size: 17.w),
                            ),
                            SizedBox(
                              width: 8.w,
                              child: Text('$quantity', textAlign: TextAlign.center, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              onPressed: quantity < product.stock ? () => onQuantityChanged(quantity + 1) : null,
                              icon: Icon(Icons.add, size: 17.w),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 110.w,
                        child: Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (quantity > 0) {
                                onQuantityChanged(quantity);
                              } else {
                                onQuantityChanged(1);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.green : const Color(0xffE20613),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            // child: Text(isSelected ? 'Selected ($quantity)' : 'Add to Order'),
                            child: Text(
                                textAlign: TextAlign.center,
                                isSelected ? 'Selected' : 'Add to Order'),
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
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    final orderVM = context.read<OrderViewmodel>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: const Center(child: Text('Confirm Submission', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        content: const Text('Are you sure you want to submit today’s order?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Order of ${orderVM.productList.length} items submitted successfully!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE20613)),
            child: const Text('Yes, Submit'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/successful.png', height: 150.h),
            const SizedBox(height: 20),
            const Text('Order Submitted Successfully!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/myOrders');
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE20613)),
              child: const Text('Go to My Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
