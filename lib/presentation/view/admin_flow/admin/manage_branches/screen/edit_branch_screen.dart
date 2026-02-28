import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';

class EditBranchScreen extends StatefulWidget {
  const EditBranchScreen({super.key});

  @override
  State<EditBranchScreen> createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  // Dropdown values
  String? selectedProduct;
  String? selectedStockStatus;

  // Dropdown options
  final List<String> stockStatusOptions = ['Active', 'Inactive'];

  final ImagePicker _imagePicker = ImagePicker();

  // Image selection variables
  File? selectedImageFile;
  String? imageFormat;
  String? imageSize;

  Future<void> _selectImage() async {
    // Handle image selection logic here

    _imagePicker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        // Handle the picked image file
        File imageFile = File(pickedFile.path);

        // Get file size in MB
        int fileSizeInBytes = imageFile.lengthSync();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        // Get image format from file extension
        String extension = imageFile.path.split('.').last.toUpperCase();
        String format = (extension == 'JPG') ? 'JPEG' : extension;

        setState(() {
          selectedImageFile = imageFile;
          imageFormat = format;
          imageSize = '${fileSizeInMB.toStringAsFixed(2)} MB';
        });
      } else {
        // User canceled the picker
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ManageBranchProvider>(context, listen: false).getSingleBranch(
        Provider.of<ManageBranchProvider>(
              context,
              listen: false,
            ).singleBranchModel?.data?.id ??
            "", // Replace with actual user ID
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarTwo(
        title: 'Edit Branch',
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
            _buildTextField(
              hint: "Branch name with ID",
              controller: TextEditingController(
                text:
                    Provider.of<ManageBranchProvider>(
                      context,
                      listen: false,
                    ).singleBranchModel?.data?.name,
              ),
            ),

            SizedBox(height: 16.h),
            _buildLabel("Branch location"),
            _buildTextField(
              hint: "Add location",
              controller: TextEditingController(
                text:
                    Provider.of<ManageBranchProvider>(
                      context,
                      listen: false,
                    ).singleBranchModel?.data?.address,
              ),
            ),

            SizedBox(height: 16.h),
            _buildLabel("Status"),
            _buildStockStatusDropdown(),

            SizedBox(height: 24.h),
            _buildLabel("Upload product Image"),
            _buildImageUploader(),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Consumer<ManageBranchProvider>(
                builder: (
                  BuildContext context,
                  ManageBranchProvider provider,
                  Widget? child,
                ) {
                  final data = provider.singleBranchModel?.data;

                  return AuthButton(
                    text: Text(
                      'Save & Update',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      // Handle save and update logic here
                      provider.updateBranch(
                        userId:
                            data?.id ?? "", // Use the actual user ID from data
                        name: data?.name ?? "", // Use the actual name from data
                        address:
                            data?.address ??
                            "", // Use the actual address from data
                        status: selectedStockStatus ?? "Active",
                        // image: selectedImage, // Handle image selection logic
                      );
                    },
                    color: AppColors.primaryColor,
                  );
                },
              ),
            ),
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

  Widget _buildTextField({String? hint, TextEditingController? controller}) =>
      TextField(
        controller: controller ?? TextEditingController(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          filled: true,
          fillColor: AppColors.editTextFieldColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
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
        hint: Text("Select", style: TextStyle(color: Colors.grey[500])),
        dropdownColor:
            AppColors.editTextFieldColor, // Dropdown menu background color
        borderRadius: BorderRadius.circular(8.r), // Dropdown menu border radius
        style: TextStyle(color: Colors.grey[600]), // Dropdown item text color
        items:
            stockStatusOptions.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
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
    height: selectedImageFile != null ? 200.h : 160.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: const Color(0xFFD2D2D5)),
      color: AppColors.editTextFieldColor,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _selectImage(),
            child: Container(
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
          ),
          SizedBox(height: 16.h),
          if (selectedImageFile != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Read-only Format Field
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock, size: 16.sp, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Format',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              imageFormat ?? 'Unknown',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                // Read-only Size Field
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock, size: 16.sp, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'File Size',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              imageSize ?? 'Unknown',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Text(
              "JPEG, PNG up to 50 MB",
              style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
            ),
        ],
      ),
    ),
  );
}
