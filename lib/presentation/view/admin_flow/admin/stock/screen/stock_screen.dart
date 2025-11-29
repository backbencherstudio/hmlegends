import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../../../core/route/route_names.dart';
import '../../../../widget/custom_app_bar.dart';
import '../../../../widget/custom_text_field.dart';
import '../../../../widget/dialog_button.dart';
import '../../../admin_model/admin_product_model.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../../../view_model/stock/stock_screen_provider.dart';
import '../widget/edit_dialog.dart';

class StockScreen extends StatefulWidget {
  final bool fromBottomNav;
  const StockScreen({super.key, required this.fromBottomNav});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  File? image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

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

  void showDeleteStockDialog(
    BuildContext context,
    String text,
    String productId,
  ) {
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

                SuccessDeleteStock(
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

  void SuccessDeleteStock(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(dialogContext).pop();
          Navigator.of(
            dialogContext,
          ).pushReplacementNamed(RouteNames.mainWrapper);
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
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
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    return Consumer<StockScreenProvider>(
      builder: (context, vm, child) {
        final products = vm.adminProductModel?.data ?? [];
        final filteredProducts = filterProducts(products, vm.selectIndex);

        return Scaffold(
          backgroundColor: Colors.white,

          appBar: CustomAppBar(
            profileImage: data?.avatar,
            notificationCount: 4,
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
                                      ? const Color(0xFFFCEBE9)
                                      : const Color(0xFFF1F0EE),
                            ),
                            child: Center(
                              child: Text(
                                vm.data![index],
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? const Color(0xFFE20613)
                                          : const Color(0xFF4A4C56),
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

                    GestureDetector(
                      onTap: () {
                        _showAddProductDialog();
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffE20613),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
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
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child:
                      vm.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 6.h),
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.4,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 90.w,
                                      height: 90.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        image:
                                            product.image != null
                                                ? DecorationImage(
                                                  image: NetworkImage(
                                                    product.image!,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                                : null,
                                        color:
                                            product.image == null
                                                ? Colors.grey[300]
                                                : null,
                                      ),
                                      child:
                                          product.image == null
                                              ? const Icon(
                                                Icons.image,
                                                size: 30,
                                              )
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

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Stock: ${product.stock} pcs",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade800,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      product.stockStatus ==
                                                              "IN_STOCK"
                                                          ? Colors.green
                                                              .withOpacity(0.15)
                                                          : product
                                                                  .stockStatus ==
                                                              "LOW_STOCK"
                                                          ? Colors.orange
                                                              .withOpacity(0.15)
                                                          : Colors.red
                                                              .withOpacity(
                                                                0.15,
                                                              ),
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
                                                              ? Colors.green
                                                              : product
                                                                      .stockStatus ==
                                                                  "LOW_STOCK"
                                                              ? Colors.orange
                                                              : Colors.red,
                                                    ),

                                                    Text(
                                                      product.stockStatus ?? "",
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            product.stockStatus ==
                                                                    "IN_STOCK"
                                                                ? Colors.green
                                                                : product
                                                                        .stockStatus ==
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

                                          SizedBox(height: 4.h),

                                          Row(
                                            children: [
                                              Text(
                                                "\$${product.price}",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () async {
                                                  EditDialog.showEditDialog(
                                                    context,
                                                    product.id ?? "",
                                                  );
                                                  await vm
                                                      .getSingleProductProduct(
                                                        product.id ?? "",
                                                      );
                                                },
                                                icon: Image.asset(
                                                  'assets/icons/edit_icon.png',
                                                  scale: 3.5,
                                                ),
                                              ),

                                              // IconButton(
                                              //   onPressed: () async {
                                              //     await vm.deleteProduct(
                                              //       product.id ?? "",
                                              //     );
                                              //   },
                                              //   icon: Image.asset(
                                              //         'assets/icons/deleteIcon.png',
                                              //         scale: 3,
                                              //       ),
                                              // ),
                                              InkWell(
                                                onTap: () async {
                                                  showDeleteStockDialog(
                                                    context,
                                                    'Are you sure you want to delete this item?',
                                                    product.id ?? "",
                                                  );
                                                },
                                                child: Image.asset(
                                                  'assets/icons/deleteIcon.png',
                                                  scale: 3,
                                                ),
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
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (_) {
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
                    "Add New Product",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        image:
                            image != null
                                ? DecorationImage(
                                  image: FileImage(image!),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          image == null
                              ? const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              )
                              : null,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  CustomTextField(
                    hint: "Product Name",
                    controller: _nameController,
                  ),
                  SizedBox(height: 12.h),

                  CustomTextField(hint: "Price", controller: _priceController),
                  SizedBox(height: 12.h),

                  CustomTextField(hint: "Stock", controller: _stockController),

                  SizedBox(height: 20.h),

                  Consumer<StockScreenProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              clearInput();
                              Navigator.pop(context);
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
                            ),
                            onPressed: () async {
                              await provider.createProduct(
                                name: _nameController.text,
                                stock: _stockController.text,
                                price: _priceController.text,
                                image: image,
                              );

                              clearInput();
                              Navigator.pop(context);

                              provider.getProduct();
                            },
                            child: const Text("Save"),
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
  }
}
