import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constant/asset_path.dart';

class AssignDriverSheet extends StatefulWidget {
  final VoidCallback onSend;

  const AssignDriverSheet({super.key, required this.onSend});

  @override
  State<AssignDriverSheet> createState() => _AssignDriverSheetState();
}

class _AssignDriverSheetState extends State<AssignDriverSheet> {
  final selected = <String>{};

  final List<Map<String, Object>> items = [
    {"name": "Peri Chicken Wrap", "qty": 20},
    {"name": "Nashville Loaded Fries", "qty": 22},
    {"name": "Chicken Steak & Rice", "qty": 25},
    {"name": "The Tyson", "qty": 31},
    {"name": "The CR7", "qty": 27},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // small drag bar
            Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Driver Info Fields
            _buildReadOnlyField("Driver’s Name", "Cameron Williamson"),
            SizedBox(height: 12.h),
            _buildReadOnlyField("Driver’s ID", "CW051895"),
            SizedBox(height: 15.h),

            // Total Products
            Text(
              "Total Products: ${items.length}",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff111111),
              ),
            ),
            SizedBox(height: 8.h),
            Divider(thickness: 1, color: Colors.grey.shade300),

            // Product List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final itemName = item['name'] as String;
                final qty = item['qty'] as int;
                final isSelected = selected.contains(itemName);

                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected
                            ? selected.remove(itemName)
                            : selected.add(itemName);
                      });
                    },
                    child: Image.asset(
                      AssetPaths.thikIcon,
                      width: 20.w,
                      height: 20.h,
                      color: isSelected
                          ? const Color(0xffE20613)
                          : Colors.grey.shade400,
                    ),
                  ),
                  title: Text(
                    itemName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    "($qty)",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15.sp,
                    ),
                  ),
                );
              },
            ),

            Divider(thickness: 1, color: Colors.grey.shade300),
            SizedBox(height: 10.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xffE20613)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: const Color(0xffE20613),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSend();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE20613),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      "Send",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
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

  /// 🔹 Reusable text field builder
  Widget _buildReadOnlyField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff333333),
          ),
        ),
        SizedBox(height: 5.h),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
            TextStyle(color: Colors.grey.shade700, fontSize: 15.sp),
            filled: true,
            fillColor: const Color(0xffF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
