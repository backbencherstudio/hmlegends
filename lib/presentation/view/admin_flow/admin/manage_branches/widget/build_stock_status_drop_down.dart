import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../view_model/manage_branch_provider.dart';

class BuildStockStatusDropDown extends StatelessWidget {
  const BuildStockStatusDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManageBranchProvider>();
    final stockStatusOptions = provider.stockStatusOptions;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD2D2D5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: provider.selectedStockStatus,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          hint: Text("Select", style: TextStyle(color: Colors.grey[500])),
          dropdownColor: AppColors.editTextFieldColor,
          borderRadius: BorderRadius.circular(8.r),
          style: TextStyle(color: Colors.grey[600]),
          items:
              stockStatusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (String? newValue) {
            provider.toggleStockStatus(newValue);
          },
        ),
      ),
    );
  }
}
