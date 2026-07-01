import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/widget/search_filter.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:provider/provider.dart';
import '../../../../admin_flow/view_model/profile/change_pass_provider.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../data/get_all_products_model.dart';
import '../../data/create_order_model.dart';
import '../../viewmodel/create_order_viewmodel.dart';
import '../../viewmodel/get_all_product_viewmodel.dart';
import '../../../../admin_flow/view_model/parent/bottom_nav_viewmodel.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Set<String> _confirmedProductIds = {};
  bool _isSynced = false;

  void _syncConfirmedProducts(List<Products> products) {
    if (_isSynced || products.isEmpty) return;
    final selectProvider = Provider.of<GetProductsViewmodel>(context, listen: false);
    for (var product in products) {
      final qty = selectProvider.getQuantity(product.id);
      if (qty > 0) {
        _confirmedProductIds.add(product.id);
        _quantityNotifiers.putIfAbsent(product.id, () => ValueNotifier<int>(qty));
      }
    }
    _isSynced = true;
  }

  @override
  void initState() {
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<GetProductsViewmodel>().fetchProducts();
    });
    super.initState();
  }

  final Map<String, ValueNotifier<int>> _quantityNotifiers = {};

  @override
  void dispose() {
    for (var notifier in _quantityNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  Timer? debouncer;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ChangePasswordProvider>(
      context,
      listen: false,
    );
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<BottomNavViewModel>().updateIndex(0);
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFFF6F7),
        appBar: CustomAppBarTwo(
          title: "Place Order",
          profileImage: data?.avatar,
          notificationCount: notificationProvider.unreadCount,
          colorMain: Colors.white,
          colorSpace: const Color(0xffFFF6F7),
          onBackTap: () {
            context.read<BottomNavViewModel>().updateIndex(0);
            Navigator.pop(context);
          },
          onProfileTap: () {
            context.read<BottomNavViewModel>().updateIndex(3);
            Navigator.pop(context);
          },
        ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            /// ------------------ Total Item Summary --------------------------
            Consumer<GetProductsViewmodel>(
              builder: (context, provider, child) {
                final total = provider.totalSelectedItems;
                if (total <= 0) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
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
                            'Total items Selected: $total',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ElevatedButton(
                            onPressed:
                                total > 0 ? () => _showSubmitDialog(context) : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  total > 0
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
                  ],
                );
              },
            ),

            /// ----------------------- Search bar -----------------------------
            SearchField(
              hintText: 'Search by product name',
              text: context.watch<GetProductsViewmodel>().query,
              onChanged: (value) {
                context.read<GetProductsViewmodel>().query = value;
              },
            ),

            SizedBox(height: 20.h),

            /// ------------------- Product List -------------------------------
            Expanded(
              child: Consumer<GetProductsViewmodel>(
                builder: (context, vm, child) {
                  _syncConfirmedProducts(vm.products);

                  if (vm.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.sp,
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
                            child: Text(
                              "Retry",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final productsToDisplay = vm.filteredProducts;

                  if (productsToDisplay.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 48.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "No products available",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Consumer<GetProductsViewmodel>(
                    builder: (context, selectProvider, child) {
                      return ListView.builder(
                        itemCount: productsToDisplay.length,
                        itemBuilder: (context, index) {
                          final product = productsToDisplay[index];
                          final qty = selectProvider.getQuantity(product.id);

                          return _buildProductCard(
                            product,
                            qty,
                            _confirmedProductIds.contains(product.id),
                            () {
                              // Confirm/Selected button tapped
                              final isCurrentlyConfirmed = _confirmedProductIds.contains(product.id);
                              if (isCurrentlyConfirmed) {
                                // Unconfirm it
                                setState(() {
                                  _confirmedProductIds.remove(product.id);
                                });
                                selectProvider.updateQuantity(product.id, 0);
                                context.read<OrderViewmodel>().removeProduct(product.id);
                              } else {
                                // Confirm it
                                final currentVal = _quantityNotifiers[product.id]?.value ?? 1;
                                final newQty = currentVal > 0 ? currentVal : 1;
                                setState(() {
                                  _confirmedProductIds.add(product.id);
                                  _quantityNotifiers[product.id]?.value = newQty;
                                });
                                selectProvider.updateQuantity(product.id, newQty);
                                context.read<OrderViewmodel>().addProduct(
                                  ProductSelectModel(
                                    productId: product.id,
                                    productQty: newQty.toString(),
                                  ),
                                );
                              }
                            },
                            (newQty) {
                              // Quantity changed (+ or - tapped)
                              final isCurrentlyConfirmed = _confirmedProductIds.contains(product.id);
                              if (isCurrentlyConfirmed) {
                                // Update provider in real-time if it's already confirmed
                                selectProvider.updateQuantity(product.id, newQty);
                                if (newQty > 0) {
                                  context.read<OrderViewmodel>().addProduct(
                                    ProductSelectModel(
                                      productId: product.id,
                                      productQty: newQty.toString(),
                                    ),
                                  );
                                } else {
                                  // If they decremented to 0, unconfirm it too
                                  setState(() {
                                    _confirmedProductIds.remove(product.id);
                                    _quantityNotifiers[product.id]?.value = 1; // reset local UI to 1
                                  });
                                  context.read<OrderViewmodel>().removeProduct(product.id);
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
   );
  }

  /// ---------------------- PRODUCT CARD --------------------------------------
  Widget _buildProductCard(
    Products product,
    int quantity,
    bool isConfirmed,
    VoidCallback onConfirmTapped,
    Function(int) onQuantityChanged,
  ) {
    /// -------------- Get or create ValueNotifier for this product ------------
    final quantityNotifier = _quantityNotifiers.putIfAbsent(
      product.id,
      () => ValueNotifier<int>(quantity > 0 ? quantity : 1),
    );

    /// Update notifier if quantity changed externally
    if (isConfirmed && quantityNotifier.value != quantity) {
      quantityNotifier.value = quantity;
    }
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
                    image: product.image ?? "N/A",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  SizedBox(height: 6.h),

                  Text(
                    ' Stock: ${product.stock} pcs',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF5C5C5C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  /// ----------------------- Quantity + Button ----------------
                  Row(
                    children: [
                      Container(
                        width: 110.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  if (quantityNotifier.value > 0) {
                                    final newQty = quantityNotifier.value - 1;
                                    if (newQty == 0 && !isConfirmed) {
                                      // Don't allow decrementing below 1 if not confirmed
                                      return;
                                    }
                                    quantityNotifier.value = newQty;
                                    onQuantityChanged(newQty);
                                  }
                                },
                                icon: Icon(Icons.remove, size: 17.w),
                              ),
                            ),
                            Expanded(
                              child: ValueListenableBuilder(
                                valueListenable: quantityNotifier,
                                builder: (context, value, child) {
                                  return SizedBox(
                                    width: 15.w,
                                    child: Text(
                                      '$value',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  if (quantityNotifier.value < product.stock) {
                                    final newQty = quantityNotifier.value + 1;
                                    quantityNotifier.value = newQty;
                                    onQuantityChanged(newQty);
                                  }
                                },
                                icon: Icon(Icons.add, size: 17.w),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 10.w),

                      /// ----------------- Add / Selected Button --------------
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onConfirmTapped,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isConfirmed
                                    ? Colors.green
                                    : const Color(0xffE20613),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isConfirmed ? 'Selected' : 'Confirm',
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

    final res = await orderVM.placeOrder();

    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    if (!res.success) {
      // ignore: use_build_context_synchronously
      _showErrorDialog(context, res.message);
      return;
    }

    orderVM.clearCart();
    orderVM.fetchTodayOrderStatus();

    // ignore: use_build_context_synchronously
    _showSuccessDialog(context);
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Text(
          'Submission Failed',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE20613),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            // ignore: use_build_context_synchronously
            context.read<BottomNavViewModel>().updateIndex(0);

            // Pop success dialog
            // ignore: use_build_context_synchronously
            if (Navigator.canPop(dialogContext)) {
              // ignore: use_build_context_synchronously
              Navigator.pop(dialogContext);
            }

            // ignore: use_build_context_synchronously
            if (Navigator.canPop(context)) {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          }
        });

        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: 335.w,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/successful_icon.png',
                  height: 110.h,
                  width: 110.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 32.h),
                Text(
                  'You have successfully submited the order!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1E293B),
                    height: 1.4,
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
