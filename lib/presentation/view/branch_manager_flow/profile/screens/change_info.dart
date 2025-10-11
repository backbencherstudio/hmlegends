import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeInfo extends StatelessWidget {
  const ChangeInfo({super.key});

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        actions: [
          Column(
            spacing: 10.h,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Discard Changes?',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              Text(
                'Unsaved changes will be lost',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff4A4C56),
                ),
              ),
              SizedBox(height: 10.h),
              Column(
                spacing: 6.h,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showSubmitDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE20613),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 120.w, vertical: 8.h),
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xffE20613),
                      side: const BorderSide(color: Color(0xffE20613)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.w, vertical: 8.h),
                    ),
                    child: Text(
                      'No, Keep',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: const Color(0xffE20613),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),

                  // Save Button
                  TextButton(
                    onPressed: () => _showSubmitDialog(context),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: const Color(0xffE20613),
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const _ProfileHeader(),
            SizedBox(height: 16.h),
            const LabeledInputField(
              label: 'First Name',
              placeholder: 'Protiva',
            ),
            const LabeledInputField(
              label: 'Last Name',
              placeholder: 'Bose',
            ),
            const LabeledInputField(
              label: 'Occupation',
              placeholder: "Head of Legends's branch-02",
            ),
            const LabeledInputField(
              label: 'Date of birth',
              placeholder: '10/06/1990',
            ),
            const LabeledInputField(
              label: 'Phone Number',
              placeholder: '+123-254-2530',
              isNumeric: true,
            ),
            const LabeledInputField(
              label: 'City',
              placeholder: 'Boston, MA',
            ),
            const LabeledInputField(
              label: 'Address',
              placeholder: '123 Main St, Apt 4B',
              isMultiline: true,
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE20613),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/panda.jpeg',
                    scale: 2.7,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: -5.h,
                  right: -5.w,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2)
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: const Color(0xFFD32F2F),
                      size: 19.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              'Cameron Williamson',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Head of Legends's branch-02",
              style: TextStyle(
                color: const Color(0xFFF0F0F0),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
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

  const LabeledInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.isNumeric = false,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: const Color(0xff4A4C56),
              ),
            ),
          ),
          TextField(
            maxLines: isMultiline ? 3 : 1,
            keyboardType: isNumeric
                ? TextInputType.phone
                : TextInputType.text,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: const Color(0xff777980)),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h, horizontal: 16.w),
              filled: true,
              fillColor: const Color(0xffF6F6F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide:
                BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: const BorderSide(
                    color: Color(0xffE20613), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(
                    color: Colors.grey.shade400, width: 1.5),
              ),
            ),
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
