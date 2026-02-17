import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';

class EditStockScreen extends StatefulWidget {
  const EditStockScreen({super.key});

  @override
  State<EditStockScreen> createState() => _EditStockScreenState();
}

class _EditStockScreenState extends State<EditStockScreen> {
  // Dropdown values
  String? selectedProduct;
  String? selectedStockStatus;

  // Dropdown options
  final List<String> productOptions = ['Chicken Steak & Chips'];
  final List<String> stockStatusOptions = ['in stock', 'low stock', 'out of stock'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarTwo(
        title: 'Edit Stock',
        notificationCount: 4,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        onBackTap: () => Navigator.pop(context),
        profileImage: AssetPaths.personIcon,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Product Name"),
            _buildProductDropdown(),

            SizedBox(height: 16.h),
            _buildLabel("Stock Quantity"),
            _buildTextField("Write quantity"),

            SizedBox(height: 16.h),
            _buildLabel("Product Price"),
            _buildTextField("Write price"),

            SizedBox(height: 16.h),
            _buildLabel("Stock Status"),
            _buildStockStatusDropdown(),

            SizedBox(height: 24.h),
            _buildLabel("Upload product Image"),
            _buildImageUploader(),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AuthButton(text: Text('Save & Update'), onPressed: (){}, color: AppColors.primaryColor),
            )
          ],
        ),
      ),
    );
  }

  // Label Widget
  Widget _buildLabel(String text) => Padding(
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

  // TextField
  Widget _buildTextField(String hint) => TextField(
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

  // Product Dropdown
  Widget _buildProductDropdown() => Container(
    decoration: BoxDecoration(
      color: AppColors.editTextFieldColor,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: const Color(0xFFD2D2D5)),
    ),
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedProduct,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        hint: Text(
          "Enter product name",
          style: TextStyle(color: Colors.grey[500]),
        ),
        dropdownColor: AppColors.editTextFieldColor, // Dropdown menu background color
        borderRadius: BorderRadius.circular(8.r), // Dropdown menu border radius
        style: TextStyle(color: Colors.grey[600]), // Dropdown item text color
        items: productOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedProduct = newValue;
          });
        },
      ),
    ),
  );

  // Stock Status Dropdown
  Widget _buildStockStatusDropdown() => Container(
    decoration: BoxDecoration(
      color: AppColors.editTextFieldColor,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: const Color(0xFFD2D2D5)),
    ),
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedStockStatus,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        hint: Text(
          "Select",
          style: TextStyle(color: Colors.grey[500]),
        ),
        dropdownColor: AppColors.editTextFieldColor, // Dropdown menu background color
        borderRadius: BorderRadius.circular(8.r), // Dropdown menu border radius
        style: TextStyle(color: Colors.grey[600]), // Dropdown item text color
        items: stockStatusOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedStockStatus = newValue;
          });
        },
      ),
    ),
  );

  // Upload Image Box
  Widget _buildImageUploader() => Container(
    width: double.infinity,
    height: 160.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: const Color(0xFFD2D2D5)),
      color: AppColors.editTextFieldColor,
    ),
    child: Center(
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
                Image.asset(AssetPaths.addIcon1,height: 20.h,width: 20.w,),
                SizedBox(width: 6.w),
                const Text(
                  'Upload photos',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
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
    ),
  );
}