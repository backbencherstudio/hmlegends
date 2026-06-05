import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/validator/validator.dart';
import 'package:hmlegends/presentation/view/driver_flow/model_view/driver_profile_screen_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/asset_path.dart';

class ChangeInfoDriver extends StatefulWidget {
  const ChangeInfoDriver({super.key});

  @override
  State<ChangeInfoDriver> createState() =>
      _HeadOfficeChangeInfoScreenState();
}

class _HeadOfficeChangeInfoScreenState
    extends State<ChangeInfoDriver> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedImage;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final provider = Provider.of<DriverProfileScreenProvider>(
      context,
      listen: false,
    );
    await provider.checkMeDriver();
    final data = provider.checkMeModelDriver?.data;

    if (data != null) {
      _firstNameController.text = data.firstName ?? "";
      _lastNameController.text = data.lastName ?? "";
      _occupationController.text = data.occupation ?? "";
      _dateOfBirthController.text = data.dateOfBirth ?? "";
      _phoneController.text = data.phoneNumber ?? "";
      _cityController.text = data.city ?? "";
      _addressController.text = data.address ?? "";
      _existingImageUrl = data.avatar;
    }

    setState(() {});
  }

  Future<void> chooseImage() async {
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
  Widget build(BuildContext context) {
    final provider = context.watch<DriverProfileScreenProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: const Text(
          "Update Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE20613),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(
              pickedImage: _selectedImage,
              imageUrl: _existingImageUrl,
              fname: _firstNameController.text,
              lname: _lastNameController.text,
              onImagePick: chooseImage,
              occupation: _occupationController.text,
              phoneController: _phoneController.text,
              addressController: _addressController.text,
            ),

            LabeledInputField(
              label: "First Name",
              placeholder: "",
              controller: _firstNameController, validator: nameValidator,
            ),
            LabeledInputField(
              label: "Last Name",
              placeholder: "",
              controller: _lastNameController, validator: nameValidator,
            ),
            LabeledInputField(
              label: "Occupation",
              placeholder: "",
              controller: _occupationController, validator: (String? value) { 
                if (value == null || value.trim().isEmpty) {
                  return 'Occupation cannot be empty';
                }
                return null;
               },
            ),
            LabeledInputField(
              label: "Date of Birth",
              placeholder: "YYYY-MM-DD",
              controller: _dateOfBirthController, validator: (String? value) { 
                if (value == null || value.trim().isEmpty) {
                  return 'Date of Birth cannot be empty';
                }
                // Simple regex for YYYY-MM-DD format
                final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                if (!regex.hasMatch(value)) {
                  return 'Date of Birth must be in YYYY-MM-DD format';
                }
                return null;
               },
            ),
            LabeledInputField(
              label: "Phone Number",
              placeholder: "",
              controller: _phoneController,
              isNumeric: true, validator: (String? value) { 
                if (value == null || value.trim().isEmpty) {
                  return 'Phone Number cannot be empty';
                }
                return null;
               },
            ),
            LabeledInputField(
              label: "City",
              placeholder: "",
              controller: _cityController, validator: (String? value) { 
                if (value == null || value.trim().isEmpty) {
                  return 'City cannot be empty';
                }
                return null;
               },
            ),
            LabeledInputField(
              label: "Address",
              placeholder: "",
              controller: _addressController,
              isMultiline: true, validator: (String? value) { 
                if (value == null || value.trim().isEmpty) {
                  return 'Address cannot be empty';
                }
                return null;
               },
            ),

            SizedBox(height: 20.h),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: () async {
                  final success = await provider.updateDriverProfile(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    occupation: _occupationController.text,
                    dateOfBirth: _dateOfBirthController.text,
                    phoneNumber: _phoneController.text,
                    city: _cityController.text,
                    address: _addressController.text,
                    image: _selectedImage,
                  );

                  if(success){
                    debugPrint('========');
                    // ignore: use_build_context_synchronously
                    await context.read<DriverProfileScreenProvider>().checkMeDriver();
                  }

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? "Profile updated successfully"
                            : "Failed to update profile",
                      ),
                    ),
                  );
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
                  "Save",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final File? pickedImage;
  final String? imageUrl;
  final String fname;
  final String lname;
  final String occupation;
  final String phoneController;
  final String addressController;
  final VoidCallback onImagePick;

  const _ProfileHeader({
    this.pickedImage,
    this.imageUrl,
    required this.fname,
    required this.lname,
    required this.onImagePick,
    required this.occupation,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    Widget displayImage;

    final provider =  context.watch<DriverProfileScreenProvider>();

    if (pickedImage != null) {
      displayImage = Image.file(
        pickedImage!,
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      displayImage = Image.network(
        "${ApiEndpoints.baseUrl}/storage/avatar/$imageUrl",
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
      );
    } else {
      displayImage = Image.asset(
        AssetPaths.personIcon,
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE20613), Color(0xFFD91A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(child: displayImage),
                Positioned(
                  bottom: -6.h,
                  right: -6.w,
                  child: GestureDetector(
                    onTap: onImagePick,
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFFE20613),
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              "${provider.checkMeModelDriver?.data?.firstName} ${provider.checkMeModelDriver?.data?.lastName}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              provider.checkMeModelDriver?.data?.occupation ?? '',
              style: TextStyle(
                color: Colors.white.withValues(alpha:0.9),
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool isNumeric;
  final bool isMultiline;
  final TextEditingController controller;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isNumeric = false,
    this.isMultiline = false, required String? Function(String? value) validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 6.h),
          TextField(
            controller: controller,
            maxLines: isMultiline ? 3 : 1,
            keyboardType: isNumeric ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(
              hintText: placeholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
