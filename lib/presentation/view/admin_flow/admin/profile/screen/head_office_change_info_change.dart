import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';

class HeadOfficeChangeInfoScreen extends StatelessWidget {
  const HeadOfficeChangeInfoScreen({super.key});

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        contentPadding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 20.h),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Discard Changes?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E1E1E),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Unsaved changes will be lost.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF777980),
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            Column(
              children: [
                // Yes button
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // discard logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE20613),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Yes, Discard',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // No button
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xffE20613), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'No, Keep Editing',
                      style: TextStyle(
                        color: const Color(0xffE20613),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            SizedBox(height: 28.h),

            // AppBar Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
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
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      color: const Color(0xFF111111),
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp,
                      letterSpacing: 0.2,
                    ),
                  ),

                  // Save Button
                  TextButton(
                    onPressed: () => _showSubmitDialog(context),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: const Color(0xffE20613),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const _ProfileHeader(),
            SizedBox(height: 18.h),

            // Input Fields
            const LabeledInputField(label: 'First Name', placeholder: 'Shahzalal'),
            const LabeledInputField(label: 'Last Name', placeholder: 'Boy'),
            const LabeledInputField(
              label: 'Occupation',
              placeholder: "Head of Legends's branch-02",
            ),
            const LabeledInputField(label: 'Date of Birth', placeholder: '10/06/1990'),
            const LabeledInputField(
              label: 'Phone Number',
              placeholder: '+123-254-2530',
              isNumeric: true,
            ),
            const LabeledInputField(label: 'City', placeholder: 'Boston, MA'),
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

// 🧑‍💼 Profile Header Card
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
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
            color: Colors.black.withOpacity(0.08),
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
                ClipOval(
                  child: Image.asset(
                    AssetPaths.personIcon,
                    scale: 2.7,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: -6.h,
                  right: -6.w,
                  child: Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2)
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFFE20613),
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              'Hamza Chowdhury',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              "Head of Legends",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🧾 Custom Input Field
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
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 6.h),
          TextField(
            maxLines: isMultiline ? 3 : 1,
            keyboardType: isNumeric ? TextInputType.phone : TextInputType.text,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF111111),
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              EdgeInsets.symmetric(vertical: 14.h, horizontal: 18.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
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
