import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_delivery/view_model/delivery_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/asset_path.dart';

class AssignDriverSheet extends StatefulWidget {
  final String? deliveryId;

  const AssignDriverSheet({super.key, required this.deliveryId});

  @override
  State<AssignDriverSheet> createState() => _AssignDriverSheetState();
}

class _AssignDriverSheetState extends State<AssignDriverSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllDrivers();
    });
  }

  Future<void> _loadAllDrivers() async {
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

          /// ----------------------  DELIVERY FIND ----------------------------
          final selectedDeliveryList =
              deliveries.where((d) => d.id == widget.deliveryId).toList();

          final selectedDelivery =
              selectedDeliveryList.isNotEmpty
                  ? selectedDeliveryList.first
                  : null;

          /// ------------------------------ORDER ITEMS ------------------------
          final orderItems = selectedDelivery?.orderItems ?? [];

          int totalQuantity = 0;
          for (var item in orderItems) {
            totalQuantity += item.quantity ?? 0;
          }
          log("===========Delivery Id : ${widget.deliveryId} ======");
          log("===========Total Quantity : $totalQuantity ========");
          String productName =
              orderItems.isNotEmpty
                  ? orderItems.first.product?.name ?? "Unknown Product"
                  : "Unknown Product";

          /// --------------------- SET DEFAULT DRIVER ------------------------
          if (drivers.isNotEmpty && provider.selectedDriverId == null) {
            provider.selectedDriverId = drivers.first.id;
            provider.selectedDriverName = drivers.first.name;
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
                /// ------------------------ Drag Bar --------------------------
                Container(
                  width: 50.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 20.h),

                /// --------------------- Driver Dropdown ----------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Driver",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
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
                          value: provider.selectedDriverName,
                          isExpanded: true,
                          hint: const Text("Select Driver"),
                          items:
                              drivers.map((driver) {
                                return DropdownMenuItem<String>(
                                  value: driver.name,
                                  child: Text(driver.name ?? "Unknown Driver"),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue == null) return;

                            final selectedDriver = drivers.firstWhere(
                              (d) => d.name == newValue,
                            );

                            provider.selectedDriverId = selectedDriver.id;
                            provider.selectedDriverName = selectedDriver.name;

                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                /// ---------------- Driver ID Field ----------------
                _buildReadOnlyField(
                  "Driver’s ID",
                  provider.selectedDriverId ?? '',
                ),
                SizedBox(height: 15.h),

                /// ---------------- Loading ----------------
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  Text(
                    "Total Products: ${totalQuantity.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF4A4C56),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Divider(color: Color(0xFFE9E9EA), thickness: 1),
                  SizedBox(height: 10.h),

                  /// ----------------------- DELIVERY DATA --------------------
                  if (selectedDelivery == null)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Delivery Not Found"),
                    )
                  else
                    Builder(
                      builder: (context) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            AssetPaths.thikIcon,
                            width: 24.w,
                            height: 24.h,
                          ),
                          title: Text(
                            productName,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Text(
                            "$totalQuantity".toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),

                  SizedBox(height: 16.h),
                ],

                /// ------------------------ Buttons ---------------------------
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 36.w,
                            vertical: 14.h,
                          ),
                          side: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 36.w,
                            vertical: 14.h,
                          ),
                        ),
                        onPressed: () async {
                          if (selectedDelivery == null ||
                              provider.selectedDriverId == null) {
                            return;
                          }

                          await provider.assignToDriver(
                            selectedDelivery.id!,
                            provider.selectedDriverId!,
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        child:
                            provider.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  "Send",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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

  /// ---------------- Read Only Field ----------------
  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5.h),
        TextField(
          readOnly: true,
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            hintText: value.isEmpty ? 'No driver selected' : value,
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
