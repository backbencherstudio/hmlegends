import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/widget/search_filter.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:hmlegends/presentation/widget/custom_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../../../core/route/route_names.dart';
import '../../../../widget/custom_text_field.dart';
import '../../../../widget/dialog_button.dart';
import '../../../admin_model/admin_product_model.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../../../view_model/stock/stock_screen_provider.dart';

class StockScreen extends StatefulWidget {
  final bool fromBottomNav;

  const StockScreen({super.key, required this.fromBottomNav});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  File? image;

  /// ---------------------- TextField Controllers ----------------------------
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  /// ------------------------ Initialize State --------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockScreenProvider>().getProduct();
    });
  }

  void clearInput() {
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();
    image = null;
  }

  /// ------------------------ Show Delete Stock Dialog ------------------------
  Future<void> showDeleteStockDialog(
    BuildContext context,
    String text,
    String productId,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            DialogButton(
              text: 'Yes',
              textColor: Colors.white,
              onPressed: () async {
                Navigator.of(context).pop();

                await context.read<StockScreenProvider>().deleteProduct(
                  productId,
                );

                if (!context.mounted) return;
                _successDeleteStock(
                  context,
                  'You have successfully Deleted the stock!',
                );
              },
              color: AppColors.primaryColor,
            ),
            DialogButton(
              text: 'Cancel',
              textColor: AppColors.authHeaderTextColor,
              onPressed: () {
                Navigator.pop(context);
              },
              color: const Color(0xFFE9E9EA),
            ),
          ],
        );
      },
    );
  }

  /// ------------------------ Success Delete Stock Dialog ---------------------
  Future<void> _successDeleteStock(BuildContext context, String text) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 1), () {
          if (dialogContext.mounted) Navigator.of(dialogContext).pop();
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Container(
            width: 335.w,
            height: 451.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetPaths.successfulIcon,
                  height: 100.h,
                  width: 100.w,
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ------------------------ Filter Products --------------------------------
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

  /// ------------------------ Apply Query Filter variables --------------------
  List<Data> allProducts = [];
  String query = '';
  Timer? debouncer;

  /// ------------------------ Debounce ---------------------------------------
  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'IN_STOCK':
        return 'In Stock';
      case 'LOW_STOCK':
        return 'Low Stock';
      case 'OUT_OF_STOCK':
        return 'Out of Stock';
      default:
        return status ?? '';
    }
  }

  /// ------------------------ Apply Query Filter -----------------------------
  List<Data> _applyQueryFilter(List<Data> products) {
    if (query.trim().isEmpty) return products;
    final q = query.trim().toLowerCase();
    return products.where((product) {
      final name = product.name ?? '';
      return name.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    return Consumer<StockScreenProvider>(
      builder: (context, vm, child) {
        final products = vm.adminProductModel?.data ?? [];
        final filteredProducts = filterProducts(products, vm.selectIndex);

        return Scaffold(
          backgroundColor: AppColors.bgColor,

          appBar: CustomAppBarTwo(
            title: "Stock Management",
            profileImage: data?.avatar,
            notificationCount: notificationProvider.unreadCount,
            colorMain: AppColors.bgColor,
            colorSpace: AppColors.bgColor,
            isIconPresent: true,
            useBottomNavBack: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              children: [
                SizedBox(
                  height: 45.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vm.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final isSelected = index == vm.selectIndex;

                      return GestureDetector(
                        onTap: () => vm.toggleSelect(index),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 17.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              color:
                                  isSelected
                                      ? Color(0xFFFCEBE9)
                                      : Color(0xFFF1F0EE),
                            ),
                            child: Center(
                              child: Text(
                                vm.data![index],
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Color(0xFFE20613)
                                          : Color(0xFF4A4C56),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                SearchField(
                  hintText: 'Search by product name',
                  text: query,
                  onChanged: (String value) {
                    if (value.isEmpty) {
                      if (debouncer != null) {
                        debouncer!.cancel();
                      }
                      setState(() {
                        query = '';
                      });
                    } else {
                      debounce(() {
                        if (!mounted) return;
                        setState(() {
                          query = value;
                        });
                      }, duration: const Duration(milliseconds: 300));
                    }
                  },
                ),
                SizedBox(height: 10.h),

                Row(
                  children: [
                    Text(
                      "Stock Product",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),

                    Consumer<StockScreenProvider>(
                      builder: (context, provider, child) {
                        return GestureDetector(
                          onTap: () {
                            _showAddProductDialog(
                              onPressed: () async {
                                await provider.createProduct(
                                  name: _nameController.text,
                                  stock: _stockController.text,
                                  price: _priceController.text,
                                  image: image,
                                );

                                clearInput();
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);

                                provider.getProduct();
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffE20613),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Add New",
                                style: TextStyle(
                                  color: const Color(0xffE20613),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child:
                      vm.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : vm.adminProductModel?.data?.isEmpty ?? true
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory,
                                size: 48.sp,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "No Stocks Found",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                          : Builder(
                            builder: (context) {
                              final queryFilteredProducts = _applyQueryFilter(
                                filteredProducts,
                              );
                              return queryFilteredProducts.isEmpty
                                  ? Center(
                                    child: Text(
                                      "No products found",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: queryFilteredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product =
                                          queryFilteredProducts[index];

                                      /// -------- Stock Product Card ------------------
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 6.h,
                                        ),
                                        padding: EdgeInsets.all(12.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // /// ----------- Product Image --------------
                                            // Container(
                                            //   width: 90.w,
                                            //   height: 90.w,
                                            //   decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(8.r),
                                            //     image:
                                            //         product.image != null
                                            //             ? DecorationImage(
                                            //               image: NetworkImage(
                                            //                 product.image!,
                                            //               ),
                                            //               fit: BoxFit.cover,
                                            //             )
                                            //             : null,
                                            //     color:
                                            //         product.image == null
                                            //             ? Colors.grey[300]
                                            //             : null,
                                            //   ),
                                            //   child:
                                            //       product.image == null
                                            //           ? const Icon(
                                            //             Icons.image,
                                            //             size: 30,
                                            //           )
                                            //           : null,
                                            // ),
                                            CustomNetworkImage(
                                              imageUrl: product.image ?? "",
                                              height: 90.w,
                                              width: 90.w,
                                              borderRadius: 12.r,
                                            ),

                                            SizedBox(width: 12.w),

                                            /// ----------- Product Details ------------
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.name ?? "N/A",
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  SizedBox(height: 4.h),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Stock: ${product.stock} pcs",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade800,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8.w,
                                                              vertical: 4.h,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              product.stockStatus ==
                                                                      "IN_STOCK"
                                                                  ? Colors.green
                                                                      .withValues(
                                                                        alpha:
                                                                            0.15,
                                                                      )
                                                                  : product
                                                                          .stockStatus ==
                                                                      "LOW_STOCK"
                                                                  ? Colors
                                                                      .orange
                                                                      .withValues(
                                                                        alpha:
                                                                            0.15,
                                                                      )
                                                                  : product
                                                                          .stockStatus ==
                                                                      "OUT_OF_STOCK"
                                                                  ? Colors.red
                                                                      .withValues(
                                                                        alpha:
                                                                            0.15,
                                                                      )
                                                                  : null,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                30.r,
                                                              ),
                                                        ),
                                                        child: Row(
                                                          spacing: 5,
                                                          children: [
                                                            Icon(
                                                              Icons.circle,
                                                              size: 12.sp,
                                                              color:
                                                                  product.stockStatus ==
                                                                          "IN_STOCK"
                                                                      ? Colors
                                                                          .green
                                                                      : product
                                                                              .stockStatus ==
                                                                          "LOW_STOCK"
                                                                      ? Colors
                                                                          .orange
                                                                      : product
                                                                              .stockStatus ==
                                                                          'OUT_OF_STOCK'
                                                                      ? Colors
                                                                          .red
                                                                      : null,
                                                            ),

                                                            Text(
                                                              _statusLabel(
                                                                product
                                                                    .stockStatus,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    product.stockStatus ==
                                                                            "IN_STOCK"
                                                                        ? Colors
                                                                            .green
                                                                        : product.stockStatus ==
                                                                            "LOW_STOCK"
                                                                        ? Colors
                                                                            .orange
                                                                        : product.stockStatus ==
                                                                            'OUT_OF_STOCK'
                                                                        ? Colors
                                                                            .red
                                                                        : null,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(height: 4.h),

                                                  Row(
                                                    children: [
                                                      Text(
                                                        "\$${product.price}",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                            context,
                                                            RouteNames
                                                                .editStockScreen,
                                                            arguments: product,
                                                          );
                                                        },
                                                        icon: Image.asset(
                                                          'assets/icons/edit_icon.png',
                                                          scale: 3.5,
                                                        ),
                                                      ),
                                                      Consumer<
                                                        StockScreenProvider
                                                      >(
                                                        builder: (
                                                          BuildContext context,
                                                          StockScreenProvider
                                                          value,
                                                          Widget? child,
                                                        ) {
                                                          return InkWell(
                                                            onTap: () async {
                                                              showDeleteStockDialog(
                                                                context,
                                                                'Are you sure you want to delete this item?',
                                                                product.id ??
                                                                    "",
                                                              );
                                                            },
                                                            child: Image.asset(
                                                              'assets/icons/deleteIcon.png',
                                                              scale: 3,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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

  /// ---------------------- Show Add Product Dialog ---------------------------
  Future<void> _showAddProductDialog({required VoidCallback onPressed}) async {
    File? dialogImage;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> pickDialogImage() async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
              );
              if (picked != null) {
                setDialogState(() => dialogImage = File(picked.path));
                image = dialogImage;
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Product',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      Stack(
                        children: [
                          GestureDetector(
                            onTap: pickDialogImage,
                            child: Container(
                              height: 150.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                              ),
                              clipBehavior: Clip.hardEdge,
                              child:
                                  dialogImage != null
                                      ? Image.file(
                                        dialogImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                      : const Center(
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                            ),
                          ),
                          if (dialogImage != null)
                            Positioned(
                              top: 6.h,
                              right: 6.w,
                              child: GestureDetector(
                                onTap: () {
                                  setDialogState(() => dialogImage = null);
                                  image = null;
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(4.w),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      CustomTextField(
                        hint: "Product Name",
                        textInputAction: TextInputAction.next,
                        controller: _nameController,
                      ),
                      SizedBox(height: 12.h),

                      CustomTextField(
                        hint: "Price",
                        textInputAction: TextInputAction.next,
                        controller: _priceController,
                      ),
                      SizedBox(height: 12.h),

                      CustomTextField(
                        hint: "Stock",
                        textInputAction: TextInputAction.done,
                        controller: _stockController,
                      ),

                      SizedBox(height: 20.h),

                      Consumer<StockScreenProvider>(
                        builder: (context, provider, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  clearInput();
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffE20613),
                                  minimumSize: Size(72.w, 36.h),
                                ),
                                onPressed:
                                    provider.isLoading ? null : onPressed,
                                child:
                                    provider.isLoading
                                        ? SpinKitSpinningLines(
                                          color: Colors.white,
                                          size: 20.sp,
                                        )
                                        : const Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
