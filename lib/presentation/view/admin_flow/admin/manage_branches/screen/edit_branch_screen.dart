import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/single_branch_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';

class EditBranchScreen extends StatefulWidget {
  final String managerId;

  const EditBranchScreen({super.key, required this.managerId});

  @override
  State<EditBranchScreen> createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  // Dropdown values
  String? selectedProduct;

  final List<String> stockStatusOptions = ['ACTIVE', 'LOCKED'];

  final ImagePicker _imagePicker = ImagePicker();

  bool _isInitialized = false;
  bool _isExistingImageRemoved = false;

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

        // ignore: use_build_context_synchronously
        context.read<ManageBranchProvider>().setSelectedImageFile(imageFile);
        // ignore: use_build_context_synchronously
        context.read<ManageBranchProvider>().setImageFormat(format);
        // ignore: use_build_context_synchronously
        context.read<ManageBranchProvider>().setImageSize(
          '${fileSizeInMB.toStringAsFixed(2)} MB',
        );
      } else {}
    });
  }

  /// --------------------- Text Field Controllers -----------------------------
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// ------------------- dispose Controller -----------------------------------

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Received Manager Id : ${widget.managerId}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ManageBranchProvider>(
        context,
        listen: false,
      ).getSingleBranch(widget.managerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final singleBranchProvider = Provider.of<ManageBranchProvider>(context);
    final singleBranch = singleBranchProvider.singleBranchModel?.data;
    final branchName = singleBranch?.name;
    final branchAddress = singleBranch?.address;
    final branchStatus = singleBranch?.status;

    // Initialize controller values once branch data loads
    if (singleBranch != null && !_isInitialized) {
      _nameController.text = branchName ?? "";
      _addressController.text = branchAddress ?? "";
      _isInitialized = true;
    }

    // Set the selected status in the provider when data loads
    if (branchStatus != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (singleBranchProvider.selectedStockStatus != branchStatus) {
          singleBranchProvider.toggleStockStatus(branchStatus);
        }
      });
    }

    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    final notification = notificationProvider.adminNotificationModel?.data;
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final profile = profileProvider.adminInfoModel?.data;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBarTwo(
        title: 'Edit Branch',
        notificationCount: notification?.length ?? 0,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        onBackTap: () => Navigator.pop(context),
        profileImage: '${profile?.avatar}',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Branch name"),
              _buildTextField(
                hint: "Branch name with ID",
                controller: _nameController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a branch name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),
              _buildLabel("Branch location"),
              _buildTextField(
                hint: "Add location",
                controller: _addressController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a branch location';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),

              /// ----------------------- Status(Active/Inactive) ----------------
              _buildLabel("Status"),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.editTextFieldColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: DropdownButtonHideUnderline(
                  child: Consumer<ManageBranchProvider>(
                    builder: (context, provider, child) {
                      return DropdownButton<String>(
                        value: provider.selectedStockStatus,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        hint: Text(
                          "Select",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        dropdownColor: AppColors.editTextFieldColor,
                        borderRadius: BorderRadius.circular(8.r),
                        style: TextStyle(color: Colors.grey[600]),
                        items:
                            stockStatusOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          provider.toggleStockStatus(newValue);
                        },
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 24.h),
              _buildLabel("Upload product Image"),
              _buildImageUploader(singleBranchProvider.singleBranchModel),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Consumer<ManageBranchProvider>(
                  builder: (
                    BuildContext context,
                    ManageBranchProvider provider,
                    Widget? child,
                  ) {
                    return AuthButton(
                      text: Text(
                        'Save & Update',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final res = await provider.updateBranch(
                            managerId: widget.managerId,
                            name: _nameController.text.trim(),
                            address: _addressController.text.trim(),
                            status: provider.selectedStockStatus ?? "ACTIVE",
                            image: provider.selectedImageFile,
                          );
                          
                          if (res != null && res["success"] == true) {
                            Utils.showToast(
                              msg: res["message"] ?? 'Manager updated successfully',
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            Utils.showToast(
                              msg: res != null ? res["message"] ?? 'Failed to update branch' : 'Failed to update branch',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        }
                      },
                      color: AppColors.primaryColor,
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
  Widget _buildTextField({
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller ?? TextEditingController(),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: AppColors.editTextFieldColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
    ),
    validator: validator,
  );

  // Upload Image Box
  Widget _buildImageUploader(SingleBranchModel? singleBranchModel) {
    final provider = Provider.of<ManageBranchProvider>(context);
    final selectedFile = provider.selectedImageFile;

    final avatar = singleBranchModel?.data?.avatar ?? '';
    final String fullAvatarUrl;
    if (avatar.startsWith('http')) {
      fullAvatarUrl = avatar;
    } else if (avatar.isNotEmpty) {
      if (avatar.startsWith('/')) {
        fullAvatarUrl = "${ApiEndpoints.baseUrl}$avatar";
      } else {
        fullAvatarUrl = "${ApiEndpoints.baseUrl}/storage/avatar/$avatar";
      }
    } else {
      fullAvatarUrl = '';
    }

    final hasLocalImage = selectedFile != null;
    final hasRemoteImage = avatar.isNotEmpty && !_isExistingImageRemoved;

    if (hasLocalImage || hasRemoteImage) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.editTextFieldColor,
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: hasLocalImage
                  ? Image.file(
                      selectedFile,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180.h,
                    )
                  : Image.network(
                      fullAvatarUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180.h,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.editTextFieldColor,
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 40.sp,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
            ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () {
                if (hasLocalImage) {
                  provider.setSelectedImageFile(null);
                  provider.setImageFormat(null);
                  provider.setImageSize(null);
                } else {
                  setState(() {
                    _isExistingImageRemoved = true;
                  });
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.editTextFieldColor,
        border: Border.all(color: Colors.grey[200]!, width: 1),
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
                    Text(
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
            Text(
              "JPEG, PNG up to 50 MB",
              style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}
