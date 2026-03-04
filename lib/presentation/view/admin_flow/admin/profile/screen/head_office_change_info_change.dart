import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/network/network_service.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/profile/widget/profile_header.dart';
import 'package:hmlegends/presentation/view/driver_flow/profile_driver/changeInfo_driver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../view_model/profile/change_pass_provider.dart';

class HeadOfficeChangeInfoScreen extends StatefulWidget {
  const HeadOfficeChangeInfoScreen({super.key});

  @override
  State<HeadOfficeChangeInfoScreen> createState() =>
      _HeadOfficeChangeInfoScreenState();
}

class _HeadOfficeChangeInfoScreenState
    extends State<HeadOfficeChangeInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedImage;
  String? _existingImageUrl;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final provider = Provider.of<ChangePasswordProvider>(
      context,
      listen: false,
    );
    await provider.adminCheckMe();
    final data = provider.adminInfoModel?.data ;

    if (data != null) {
      _firstNameController.text = data.name ?? "";
      _occupationController.text = data.occupation ?? "";
      _dateOfBirthController.text = data.dateOfBirth ?? "";
      _phoneController.text = data.phoneNumber ?? "";
      _cityController.text = data.city ?? "";
      _addressController.text = data.address ?? "";
      _existingImageUrl = data.avatar;
    }

    setState(() {});
  }

  Future<void> _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _occupationController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
        ),
        title: Text(
          "Update Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              ProfileHeader(
                pickedImage: _selectedImage,
                imageUrl: _existingImageUrl,
                fname: _firstNameController.text,
                lname: _lastNameController.text,
                onImagePick: _chooseImage,
                occupation: _occupationController.text,
                phoneController: _phoneController.text,
                addressController: _addressController.text,
              ),

              LabeledInputField(
                label: "First Name",
                placeholder: "",
                controller: _firstNameController,
                validator: nameValidator,
              ),
              LabeledInputField(
                label: "Last Name",
                placeholder: "",
                controller: _lastNameController,
                validator: nameValidator,
              ),
              LabeledInputField(
                label: "Occupation",
                placeholder: "",
                controller: _occupationController,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Occupation cannot be empty";
                  }
                  return null;
                },
              ),
              LabeledInputField(
                label: "Date of Birth",
                placeholder: "YYYY-MM-DD",
                controller: _dateOfBirthController,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Date of Birth cannot be empty";
                  }
                  // Simple regex for YYYY-MM-DD format
                  final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!regex.hasMatch(value)) {
                    return "Date of Birth must be in YYYY-MM-DD format";
                  }
                  return null;
                },
              ),
              LabeledInputField(
                label: "Phone Number",
                placeholder: "",
                controller: _phoneController,
                isNumeric: true,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Phone Number cannot be empty";
                  }
                  final regex = RegExp(r'^\+?[0-9]{7,15}$');
                  if (!regex.hasMatch(value)) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              LabeledInputField(
                label: "City",
                placeholder: "",
                controller: _cityController,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "City cannot be empty";
                  }
                  return null;
                },
              ),
              LabeledInputField(
                label: "Address",
                placeholder: "",
                controller: _addressController,
                isMultiline: true,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Address cannot be empty";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await context
                          .read<ChangePasswordProvider>()
                          .updateAdminProfile(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            occupation: _occupationController.text,
                            dateOfBirth: _dateOfBirthController.text,
                            phoneNumber: _phoneController.text,
                            city: _cityController.text,
                            address: _addressController.text,
                            image: _selectedImage,
                          );

                      if (success) {
                        await context
                            .read<ChangePasswordProvider>()
                            .adminCheckMe();
                
                        logger.i(
                          "Profile updated successfully, refreshing data...",
                        );
                      }

                      Utils.showToast(
                        msg:
                            success
                                ? "Profile updated successfully"
                                : "Failed to update profile",
                        backgroundColor: success ? Colors.green : Colors.red,
                        textColor: Colors.white,
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE20613),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 15.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
