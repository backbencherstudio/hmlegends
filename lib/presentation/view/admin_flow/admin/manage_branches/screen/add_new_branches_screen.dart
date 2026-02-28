import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/view_model/manage_branch_provider.dart';
import 'package:hmlegends/presentation/view/auth/widget/auth_button.dart';
import 'package:hmlegends/presentation/widget/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/utlis/utils.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../widget/build_stock_status_drop_down.dart';

class AddNewBranchesScreen extends StatelessWidget {
  const AddNewBranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManageBranchProvider>();

    Future<void> submit() async {
      if (provider.formKey.currentState!.validate()) {
        /// ------ Call the provider method to add a new branch --
        final result = await provider.addNewBranch(
          name: provider.nameController.text,
          email: provider.emailController.text,
          password: provider.passwordController.text,
          address: provider.addressController.text,
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
          provider.formKey.currentState!.reset();
          provider.nameController.clear();
          provider.emailController.clear();
          provider.passwordController.clear();
          provider.addressController.clear();

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
        notificationCount: 4,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        onBackTap: () => Navigator.pop(context),
        profileImage: AssetPaths.personIcon,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Form(
          key: provider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Branch name"),
              customTextFormField(
                hintText: "Enter branch name",
                controller: provider.nameController,
                validator: branchNameValidator,
              ),

              SizedBox(height: 16.h),
              _buildLabel("Branch Address"),
              customTextFormField(
                hintText: "Enter branch address",
                controller: provider.addressController,
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
                controller: provider.emailController,
                validator: emailValidator,
              ),

              SizedBox(height: 16.h),
              _buildLabel("Password"),
              customTextFormField(
                hintText: "Enter your password",
                controller: provider.passwordController,
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
