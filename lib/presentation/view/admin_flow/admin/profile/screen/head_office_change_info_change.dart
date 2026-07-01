import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/network/network_service.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/profile/widget/profile_header.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/profile/widget/label_input_field.dart';
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
  final TextEditingController _fullNameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedImage;
  String? _existingImageUrl;

  final _formKey = GlobalKey<FormState>();
  String _formatDateToUI(String? apiDate) {
    if (apiDate == null || apiDate.trim().isEmpty) return "";
    try {
      final parsed = DateTime.tryParse(apiDate);
      if (parsed != null) {
        final day = parsed.day.toString().padLeft(2, '0');
        final month = parsed.month.toString().padLeft(2, '0');
        final year = parsed.year.toString();
        return "$day/$month/$year";
      }
      final parts = apiDate.split('-');
      if (parts.length == 3) {
        final year = parts[0].trim();
        final month = parts[1].trim().padLeft(2, '0');
        final day = parts[2].trim().padLeft(2, '0');
        return "$day/$month/$year";
      }
    } catch (_) {}
    return apiDate;
  }

  String _formatDateToAPI(String uiDate) {
    if (uiDate.trim().isEmpty) return "";
    try {
      final parts = uiDate.split('/');
      if (parts.length == 3) {
        final day = parts[0].trim().padLeft(2, '0');
        final month = parts[1].trim().padLeft(2, '0');
        final year = parts[2].trim();
        return "$year-$month-$day";
      }
    } catch (_) {}
    return uiDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_dateOfBirthController.text.isNotEmpty) {
      try {
        final parts = _dateOfBirthController.text.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          initialDate = DateTime(year, month, day);
        }
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE20613),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE20613),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      setState(() {
        _dateOfBirthController.text = "$day/$month/$year";
      });
    }
  }

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
    final data = provider.adminInfoModel?.data;

    if (data != null) {
      _fullNameController.text = data.name ?? "";
      _occupationController.text = data.occupation ?? "";
      _dateOfBirthController.text = _formatDateToUI(data.dateOfBirth);
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
    _fullNameController.dispose();
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
                fname: _fullNameController.text,
                onImagePick: _chooseImage,
                occupation: _occupationController.text,
                phoneController: _phoneController.text,
                addressController: _addressController.text,
              ),

              LabeledInputField(
                label: "Full Name",
                placeholder: "",
                controller: _fullNameController,
                validator: nameValidator,
              ),
              // LabeledInputField(
              //   label: "Last Name",
              //   placeholder: "",
              //   controller: _lastNameController,
              //   validator: nameValidator,
              // ),
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
                placeholder: "DD/MM/YYYY",
                controller: _dateOfBirthController,
                readOnly: true,
                onTap: () => _selectDate(context),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Color(0xFFE20613),
                  ),
                  onPressed: () => _selectDate(context),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Date of Birth cannot be empty";
                  }
                  // Simple regex for DD/MM/YYYY format
                  final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                  if (!regex.hasMatch(value)) {
                    return "Date of Birth must be in DD/MM/YYYY format";
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
                            fullName: _fullNameController.text,
                            occupation: _occupationController.text,
                            dateOfBirth: _formatDateToAPI(
                              _dateOfBirthController.text,
                            ),
                            phoneNumber: _phoneController.text,
                            city: _cityController.text,
                            address: _addressController.text,
                            image: _selectedImage,
                          );

                      if (success) {
                        // ignore: use_build_context_synchronously
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
                        // ignore: use_build_context_synchronously
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
