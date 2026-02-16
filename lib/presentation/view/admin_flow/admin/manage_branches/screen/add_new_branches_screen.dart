import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';

class AddNewBranchesScreen extends StatefulWidget {
  const AddNewBranchesScreen({super.key});

  @override
  State<AddNewBranchesScreen> createState() => _AddNewBranchesScreenState();
}

class _AddNewBranchesScreenState extends State<AddNewBranchesScreen> {
  // Dropdown values
  String? selectedProduct;
  String? selectedStockStatus;

  // Dropdown options
  final List<String> stockStatusOptions = ['Active', 'Inactive',];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarTwo(
        title: 'Add New Branch',
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
            _buildLabel("Branch name"),
            _buildTextField("Branch name with ID"),

            SizedBox(height: 16.h),
            _buildLabel("Branch location"),
            _buildTextField("Add location"),

            SizedBox(height: 16.h),
            _buildLabel("Status"),
            _buildStockStatusDropdown(),

            SizedBox(height: 16.h),
            _buildLabel("Email"),
            _buildTextField("Enter your email"),

            SizedBox(height: 16.h),
            _buildLabel("Password"),
            _buildTextField("Enter your password"),



            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AuthButton(text: 'Save & Update', onPressed: (){}, color: AppColors.primaryColor),
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

}