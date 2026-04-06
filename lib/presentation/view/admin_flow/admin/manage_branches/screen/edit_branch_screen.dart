import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/network/network_service.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../widget/build_stock_status_drop_down.dart';

class EditBranchScreen extends StatefulWidget {
  final String branchId;

  const EditBranchScreen({super.key, required this.branchId});

  @override
  State<EditBranchScreen> createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  // Dropdown values
  String? selectedProduct;

  final List<String> stockStatusOptions = ['ACTIVE', 'LOCKED'];

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _uploadImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      context.read<ManageBranchProvider>().setSelectedImageFile(
        File(pickedFile.path),
      );
    }
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
    debugPrint("Received Manager Id : ${widget.branchId}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ManageBranchProvider>(
        context,
        listen: false,
      ).getSingleBranch(widget.branchId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        colorMain: const Color(0xFFFFF5F5),
        colorSpace: const Color(0xFFFFF5F5),
        onBackTap: () => Navigator.pop(context),
        profileImage: '${profile?.avatar}',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Consumer<ManageBranchProvider>(
          builder: (context, provider, child) {
            final singleBranch = provider.singleBranchModel?.data;
            final branchName = singleBranch?.name;
            final branchAddress = singleBranch?.address;
            final branchStatus = singleBranch?.status;
            if (branchStatus != null && mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (provider.selectedStockStatus != branchStatus) {
                  provider.toggleStockStatus(branchStatus);
                }
              });
            }
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Branch name"),
                  _buildTextField(
                    hint: "Branch name with ID",
                    controller:
                        branchName != null
                            ? TextEditingController(text: branchName)
                            : null,
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
                    controller:
                        branchAddress != null
                            ? TextEditingController(text: branchAddress)
                            : null,
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
                  BuildStockStatusDropDown(),

                  SizedBox(height: 24.h),
                  _buildLabel("Upload product Image"),

                  /// ----------------------- Upload Image Box ------------------------
                  GestureDetector(
                    onTap: _uploadImage,
                    child: Container(
                      width: double.infinity,
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      clipBehavior: Clip.hardEdge,
                      // ensures image respects border radius
                      child:
                          provider.selectedImageFile != null
                              ? Image.file(
                                provider.selectedImageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    size: 32.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "Upload Image",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                  AuthButton(
                    text: Text(
                      'Save & Update',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        logger.d("Edit Branch Manager Id ${widget.branchId}");
                        provider.updateBranch(
                          branchId: widget.branchId,
                          name:
                              _nameController.text.trim().isNotEmpty
                                  ? _nameController.text.trim()
                                  : branchName ?? "",
                          address:
                              _addressController.text.trim().isNotEmpty
                                  ? _addressController.text.trim()
                                  : branchAddress ?? "",
                          status: provider.selectedStockStatus ?? "ACTIVE",
                          image: provider.selectedImageFile,
                        );
                      }
                      Navigator.pop(context);
                    },
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            );
          },
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

      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Color(0xFFE9E9EA)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Color(0xFFE9E9EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Color(0xFFE9E9EA)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
    validator: validator,
  );
}
