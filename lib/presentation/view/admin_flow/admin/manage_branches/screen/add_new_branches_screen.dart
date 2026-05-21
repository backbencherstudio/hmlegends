import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:hmlegends/presentation/widget/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/utlis/utils.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../../../view_model/notification_admin/admin_notification_provider.dart';
import '../../../view_model/profile/change_pass_provider.dart';
import '../widget/build_stock_status_drop_down.dart';

class AddNewBranchesScreen extends StatefulWidget {
  const AddNewBranchesScreen({super.key});

  @override
  State<AddNewBranchesScreen> createState() => _AddNewBranchesScreenState();
}

class _AddNewBranchesScreenState extends State<AddNewBranchesScreen> {
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
  Widget build(BuildContext context) {
    final provider = context.watch<ManageBranchProvider>();
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    final notification = notificationProvider.adminNotificationModel?.data;
    Future<void> submit() async {
      if (_formKey.currentState!.validate()) {
        /// ------ Call the provider method to add a new branch --
        final result = await provider.addNewBranch(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          address: _addressController.text,
          status: provider.selectedStockStatus ?? 'ACTIVE',
        );

        if (result['success']) {
          await provider.allBranch();

          Utils.showToast(
            msg: result['message'],
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          /// ---------------- Clear the form --------------------
          _formKey.currentState!.reset();
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _addressController.clear();

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          Utils.showToast(
            msg: result['message'],
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarTwo(
        title: 'Add New Branch',
        notificationCount: notification?.length ?? 0,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        onBackTap: () => Navigator.pop(context),
        profileImage: '${data?.avatar}',
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
              customTextFormField(
                hintText: "Enter branch name",
                controller: _nameController,
                validator: branchNameValidator,
              ),

              SizedBox(height: 16.h),
              _buildLabel("Branch Address"),
              customTextFormField(
                hintText: "Enter branch address",
                controller: _addressController,
                validator: branchAddressValidator,
              ),

              SizedBox(height: 16.h),
              _buildLabel("Status"),

              /// ----------------- Build Stock Status Drop Down ---------------
              BuildStockStatusDropDown(),

              SizedBox(height: 16.h),
              _buildLabel("Email"),
              customTextFormField(
                hintText: "Enter your email",
                controller: _emailController,
                validator: emailValidator,
              ),

              SizedBox(height: 16.h),
              _buildLabel("Password"),
              customTextFormField(
                hintText: "Enter your password",
                controller: _passwordController,
                validator: passwordValidator,
                isPassword: true,
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
                  onPressed: submit,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///-------------------------- Label Widget -----------------------------------
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
}
