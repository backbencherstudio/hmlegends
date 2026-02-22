import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_delivery/view_model/delivery_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/asset_path.dart';

class AssignDriverSheet extends StatefulWidget {
  final VoidCallback onSend;

  const AssignDriverSheet({super.key, required this.onSend});

  @override
  State<AssignDriverSheet> createState() => _AssignDriverSheetState();
}

class _AssignDriverSheetState extends State<AssignDriverSheet> {
  final selected = <String>{};
  String? selectedDriverId;
  String? selectedDriverName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDrivers();
    });
  }

  Future<void> _loadDrivers() async {
    await context.read<DeliveryProvider>().getAllDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Consumer<DeliveryProvider>(
        builder: (context, provider, child) {
          final deliveries = provider.allDeliveriesModel?.data ?? [];
          final drivers = provider.allDriversModel?.data ?? [];

          // Set initial selected driver if available and not already set
          if (drivers.isNotEmpty && selectedDriverId == null) {
            selectedDriverId = drivers.first.id;
            selectedDriverName = drivers.first.name;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 16.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ------------------- Drag Bar -------------------------------
                Container(
                  width: 50.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 20.h),

                /// ------------ Driver Selection Dropdown ------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Driver",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff333333),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.editTextFieldColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: const Color(0xFFD2D2D5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDriverName,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          hint: Text(
                            "Select Driver",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          dropdownColor: AppColors.editTextFieldColor,
                          borderRadius: BorderRadius.circular(8.r),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                          items:
                              drivers.map((driver) {
                                return DropdownMenuItem<String>(
                                  value: driver.name,
                                  child: Text(driver.name ?? 'Unknown Driver'),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDriverId = newValue;
                              // final selectedDriver = drivers.firstWhere(
                              //       (d) => d.id == newValue,
                              //   orElse: () => {},
                              // );
                              // selectedDriverName = selectedDriver.name;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                /// ------------ Driver ID Field ------------
                _buildReadOnlyField("Driver’s ID", selectedDriverId ?? ''),
                SizedBox(height: 15.h),

                /// ------------- Loading State ---------------
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  /// ------------- Total Products --------------
                  Text(
                    "Total Products: ${deliveries.length}",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff111111),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  SizedBox(height: 10.h),

                  /// ------------- Empty State --------------
                  if (deliveries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No Deliveries Found"),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: deliveries.length,
                      itemBuilder: (context, index) {
                        final item = deliveries[index];

                        /// Safe orderItems access
                        final orderItems = item.orderItems ?? [];

                        String itemName = "Unknown";
                        int qty = 0;

                        if (orderItems.isNotEmpty) {
                          final firstOrder = orderItems.first;
                          itemName = firstOrder.product?.name ?? "Unknown";
                          qty = firstOrder.quantity ?? 0;
                        }

                        final isSelected = selected.contains(itemName);

                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selected.remove(itemName);
                                } else {
                                  selected.add(itemName);
                                }
                              });
                            },
                            child: Image.asset(
                              AssetPaths.thikIcon,
                              width: 20.w,
                              height: 20.h,
                              color:
                                  isSelected
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
                ],

                /// ------------- Action Buttons --------------
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
                        onPressed:
                            selectedDriverId == null
                                ? null // Disable if no driver selected
                                : () {
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
          );
        },
      ),
    );
  }

  /// 🔹 Reusable read-only field
  Widget _buildReadOnlyField(String label, String value) {
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
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            hintText: value.isEmpty ? 'No driver selected' : value,
            hintStyle: TextStyle(
              color: value.isEmpty ? Colors.grey : Colors.black,
              fontSize: 15.sp,
            ),
            filled: true,
            fillColor: const Color(0xffF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
