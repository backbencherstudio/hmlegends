import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../admin_flow/view_model/profile/change_pass_provider.dart';
import '../../../../widget/custom_app_bar.dart';
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

  int get totalSelectedItems =>
      _selectedQuantities.values.fold(0, (sum, qty) => sum + qty);

  @override
  Widget build(BuildContext context) {
    final orderVM = context.watch<OrderViewmodel>();
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;

    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: CustomAppBar(profileImage: data?.avatar, notificationCount: 4),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            /// ------------------ Total Item Summary --------------------------
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total items Selected: $totalSelectedItems',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        totalSelectedItems > 0
                            ? () => _showSubmitDialog(context)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          totalSelectedItems > 0
                              ? const Color(0xffE20613)
                              : Colors.grey.shade100,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      'Submit Order',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// ----------------------- Search bar -----------------------------
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              height: 45.h,
              decoration: BoxDecoration(
                color: const Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Color(0xFFA5A5AB),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.sp,
                    color: Color(0xFF777980),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            /// ------------------- Product List -------------------------------
            Expanded(
              child: Consumer<GetProductsViewmodel>(
                builder: (context, vm, child) {
                  if (vm.isLoading && vm.products.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                        strokeWidth: 3,
                      ),
                    );
                  }

                  if (vm.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            vm.errorMessage,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            onPressed: () => vm.fetchProducts(),
                            child: Text("Retry"),
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
                      final qty = _selectedQuantities[product.id] ?? 0;

                      return _buildProductCard(product, qty, (newQty) {
                        setState(() {
                          if (newQty > 0) {
                            _selectedQuantities[product.id] = newQty;
                            orderVM.addProduct(
                              ProductSelectModel(
                                productId: product.id,
                                productQty: newQty.toString(),
                              ),
                            );
                          } else {
                            _selectedQuantities.remove(product.id);
                            orderVM.removeProduct(product.id);
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

  /// ---------------------- PRODUCT CARD --------------------------------------
  Widget _buildProductCard(
    Products product,
    int quantity,
    Function(int) onQuantityChanged,
  ) {
    final isSelected = quantity > 0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 0,
      shadowColor: Colors.grey.shade400,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            /// ----------------------- Image ----------------------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 92.w,
                    height: 100.h,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/main_logo.png',
                    image: product.image ?? "",
                    width: 92.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                    imageErrorBuilder:
                        (_, __, ___) => Container(
                          width: 92.w,
                          height: 100.h,
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.red,
                            size: 36.sp,
                          ),
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            /// ------------------------ Info ----------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' Stock: ${product.stock} pcs',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF5C5C5C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 20.w),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              product.stockStatus == 'IN_STOCK'
                                  ? Colors.green.shade100
                                  : product.stockStatus == 'LOW_STOCK'
                                  ? Colors.orange.shade100
                                  : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Text(
                          product.stockStatus,
                          style: TextStyle(
                            color:
                                product.stockStatus == 'IN_STOCK'
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  /// ----------------------- Quantity + Button ----------------
                  Row(
                    children: [
                      Container(
                        width: 105.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed:
                                  quantity > 0
                                      ? () => onQuantityChanged(quantity - 1)
                                      : null,
                              icon: Icon(Icons.remove, size: 17.w),
                            ),
                            SizedBox(
                              width: 8.w,
                              child: Text(
                                '$quantity',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  quantity < product.stock
                                      ? () => onQuantityChanged(quantity + 1)
                                      : null,
                              icon: Icon(Icons.add, size: 17.w),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 10.w),

                      /// ----------------- Add / Selected Button --------------
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (quantity > 0) {
                              onQuantityChanged(quantity);
                            } else {
                              onQuantityChanged(1);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected
                                    ? Colors.green
                                    : const Color(0xffE20613),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isSelected ? 'Selected' : 'Confirm',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
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

  /// -------------------- CONFIRM SUBMISSION DIALOG ---------------------------
  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              'Can’t edit after submission',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
            content: Text(
              'Are you sure you want to submit today’s order?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 20.sp,
              ),
            ),
            actions: [
              Row(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _submitOrder();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE20613),
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xff777980), fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  /// --------------------- FINAL ORDER SUBMIT LOGIC ---------------------------
  Future<void> _submitOrder() async {
    final orderVM = context.read<OrderViewmodel>();

    // Loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await orderVM.placeOrder();

    Navigator.pop(context);

    if (!success) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Order Failed'),
              content: Text(orderVM.errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    _showSuccessDialog(context);
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            content: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/myOrders');
              },
              child: Image.asset(
                'assets/images/congratulations.png',
                height: 350.h,
              ),
            ),
          ),
    );
  }
}
