import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin_model/admin_product_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/stock/stock_screen_provider.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../widget/custom_app_bar_2.dart';

class EditStockScreen extends StatefulWidget {
  final Data product;

  const EditStockScreen({super.key, required this.product});

  @override
  State<EditStockScreen> createState() => _EditStockScreenState();
}

class _EditStockScreenState extends State<EditStockScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _stockController;
  late final TextEditingController _priceController;
  late final TextEditingController _taxController;

  String? _selectedStockStatus;
  File? _pickedImage;
  bool _isSubmitting = false;
  bool _imageRemoved = false;

  static const _statusLabels = {
    'IN_STOCK': 'In stock',
    'LOW_STOCK': 'Low stock',
    'OUT_OF_STOCK': 'Out of stock',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name ?? '');
    _stockController = TextEditingController(
      text: widget.product.stock != null ? '${widget.product.stock}' : '',
    );
    _priceController = TextEditingController(
      text: widget.product.price != null ? '${widget.product.price}' : '',
    );
    _taxController = TextEditingController(
      text: widget.product.tax != null ? '${widget.product.tax}' : '',
    );
    _selectedStockStatus =
        _statusLabels.containsKey(widget.product.stockStatus)
            ? widget.product.stockStatus
            : 'IN_STOCK';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty ||
        _stockController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      Utils.showToast(
        msg: 'Please fill in all required fields',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await context.read<StockScreenProvider>().editProduct(
      pId: widget.product.id ?? '',
      name: _nameController.text.trim(),
      stock: _stockController.text.trim(),
      price: _priceController.text.trim(),
      stockStatus: _selectedStockStatus ?? 'IN_STOCK',
      tax: _taxController.text.trim(),
      image: _pickedImage,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    Utils.showToast(
      msg: result.message,
      backgroundColor: result.success ? Colors.green : Colors.red,
      textColor: Colors.white,
    );

    if (result.success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarTwo(
        title: 'Edit Stock',
        notificationCount: 0,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        onBackTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Product Name"),
            _textField("Enter product name", controller: _nameController),

            SizedBox(height: 16.h),
            _label("Stock Quantity"),
            _textField(
              "Write quantity",
              controller: _stockController,
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16.h),
            _label("Product Price"),
            _textField(
              "Write price",
              controller: _priceController,
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16.h),
            _label("Tax % (optional)"),
            _textField(
              "Write tax percentage",
              controller: _taxController,
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16.h),
            _label("Stock Status"),
            _stockStatusDropdown(),

            SizedBox(height: 24.h),
            _label("Upload product Image"),
            _imageUploader(),

            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AuthButton(
                text:
                    _isSubmitting
                        ? SpinKitSpinningLines(color: Colors.white, size: 24.sp)
                        : const Text(
                          'Save & Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                onPressed: _isSubmitting ? () {} : _save,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15.sp,
        color: Colors.black87,
      ),
    ),
  );

  Widget _textField(
    String hint, {
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: AppColors.editTextFieldColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFFD2D2D5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFFD2D2D5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFFD2D2D5)),
      ),
    ),
  );

  Widget _stockStatusDropdown() => Container(
    decoration: BoxDecoration(
      color: AppColors.editTextFieldColor,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: const Color(0xFFD2D2D5)),
    ),
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedStockStatus,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        dropdownColor: AppColors.editTextFieldColor,
        borderRadius: BorderRadius.circular(8.r),
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 14.sp,
          fontFamily: 'Poppins',
        ),
        items:
            _statusLabels.entries
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e.key,
                    child: Text(e.value),
                  ),
                )
                .toList(),
        onChanged: (value) {
          if (value != null) setState(() => _selectedStockStatus = value);
        },
      ),
    ),
  );

  Widget _imageUploader() {
    final hasNetworkImage =
        !_imageRemoved &&
        widget.product.image != null &&
        widget.product.image!.isNotEmpty;
    final showImage = _pickedImage != null || hasNetworkImage;

    return Stack(
      children: [
        GestureDetector(
          onTap: showImage ? null : _pickImage,
          child: Container(
            width: double.infinity,
            height: 160.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFD2D2D5)),
              color: AppColors.editTextFieldColor,
            ),
            child:
                _pickedImage != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(_pickedImage!, fit: BoxFit.cover),
                    )
                    : hasNetworkImage
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        widget.product.image!,
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (_, child, progress) =>
                                progress == null ? child : _uploadPlaceholder(),
                        errorBuilder: (_, __, ___) => _uploadPlaceholder(),
                      ),
                    )
                    : _uploadPlaceholder(),
          ),
        ),
        if (showImage)
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap:
                  () => setState(() {
                    _pickedImage = null;
                    _imageRemoved = true;
                  }),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(2.r),
                child: Icon(Icons.cancel, color: Colors.redAccent, size: 26.sp),
              ),
            ),
          ),
        if (!showImage)
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(2.r),
                child: Icon(
                  Icons.add_circle,
                  color: AppColors.primaryColor,
                  size: 26.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _uploadPlaceholder() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.redAccent, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AssetPaths.addIcon1, height: 20.h, width: 20.w),
              SizedBox(width: 6.w),
              const Text(
                'Upload photos',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "JPEG, PNG up to 50 MB",
          style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
        ),
      ],
    ),
  );
}
