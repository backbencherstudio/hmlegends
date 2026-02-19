import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../widget/custom_app_bar_2.dart';

class AddNewBranchesScreen extends StatefulWidget {
  const AddNewBranchesScreen({super.key});

  @override
  State<AddNewBranchesScreen> createState() => _AddNewBranchesScreenState();
}

class _AddNewBranchesScreenState extends State<AddNewBranchesScreen> {
  /// ------------ Text Field Controllers ------------
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ///-------------------- Dropdown values --------------------------------------
  String? selectedProduct;
  String? selectedStockStatus;

  /// -------------------- Dropdown options ------------------------------------
  final List<String> stockStatusOptions = ['ACTIVE', 'LOCKED'];

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
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Branch name"),
              _buildTextField(
                "Branch name with ID",
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the branch name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),
              _buildLabel("Branch location"),
              _buildTextField(
                "Add location",
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the branch location';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),
              _buildLabel("Status"),
              _buildStockStatusDropdown(),

              SizedBox(height: 16.h),
              _buildLabel("Email"),
              _buildTextField(
                "Enter your email",
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Basic email validation
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),
              _buildLabel("Password"),
              _buildTextField(
                "Enter your password",
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),

              SizedBox(height: 40.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AuthButton(
                  text:
                      context.watch<ManageBranchProvider>().isLoading
                          ? SizedBox(
                            height: 16.h,
                            width: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                          : Center(
                            child: Text(
                              'Add New Branch',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  onPressed: () async {
                    // Example of using the form data
                    if (_formKey.currentState!.validate()) {
                      // Call the provider method to add a new branch
                      final result = await context
                          .read<ManageBranchProvider>()
                          .addNewBranch(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            address: _addressController.text,
                            status: selectedStockStatus ?? 'ACTIVE',
                          );

                      if (mounted) {
                        if (result['success']) {
                          await context
                              .read<ManageBranchProvider>()
                              .allBranch();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message'].toString()),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          // Clear the form
                          _formKey.currentState!.reset();
                          _nameController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                          _addressController.clear();
                          setState(() {
                            selectedStockStatus = null;
                          });
                          // Navigate back
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message'].toString()),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    }
                  },
                  color: AppColors.primaryColor,
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
  Widget _buildTextField(
    String hint, {
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    validator: validator,
    textInputAction: TextInputAction.next,
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
        hint: Text("Select", style: TextStyle(color: Colors.grey[500])),
        dropdownColor: AppColors.editTextFieldColor,
        // Dropdown menu background color
        borderRadius: BorderRadius.circular(8.r),
        // Dropdown menu border radius
        style: TextStyle(color: Colors.grey[600]),
        // Dropdown item text color
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
}
