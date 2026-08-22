import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';
import 'package:hmlegends/presentation/view/drivier_flow/driver_home/viewmodel/driver_branch_detail_viewmodel.dart';

class DriverBranchDetailScreen extends StatefulWidget {
  const DriverBranchDetailScreen({super.key});

  @override
  State<DriverBranchDetailScreen> createState() =>
      _DriverBranchDetailScreenState();
}

class _DriverBranchDetailScreenState extends State<DriverBranchDetailScreen> {
  bool _isInit = true;
  final Set<String> _selectedItemIds = {};

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final deliveryId = args?["deliveryId"];
      if (deliveryId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<DriverBranchDetailViewModel>(
            context,
            listen: false,
          ).fetchSingleDelivery(deliveryId);
        });
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = args?["name"] ?? "Branch Name-01";
    final address =
        args?["address"] ?? "4140 Parker Rd. Allentown, New Mexico 31134";
    final productsCount = args?["products"] ?? "216";

    return Scaffold(
      appBar: const CustomAppBar(
        notificationCount: 0,
        backArrow: "true",
        isDriver: true,
      ),
      body: Consumer<DriverBranchDetailViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.deliveryData == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null && vm.deliveryData == null) {
            return Center(child: Text(vm.error!));
          }

          final orderItems = vm.deliveryData?.order?.orderItems ?? [];
          final displayName = vm.deliveryData?.order?.user?.name ?? name;
          final displayAddress =
              vm.deliveryData?.order?.user?.address ?? address;
          final status = vm.deliveryData?.status?.toUpperCase() ?? "ASSIGNED";
          final deliveryId = args?["deliveryId"] as String?;
          final isAssignedStatus = status == "ASSIGNED";

          final totalQuantity =
              vm.deliveryData?.order?.totalQuantity?.toString() ??
              productsCount;
          final availableQuantity =
              vm.deliveryData?.order?.confirmedQuantity?.toString() ??
              totalQuantity;

          String buttonText = "Delivery Done";
          VoidCallback? onButtonPressed;

          if (status == "ASSIGNED") {
            buttonText = "Received";
            onButtonPressed = () async {
              if (deliveryId == null) return;
              if (_selectedItemIds.isEmpty) {
                Utils.showToast(
                  msg: "Please select at least one item to receive",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                return;
              }
              final success = await vm.updateDeliveryStatus(
                deliveryId,
                "RECEIVED",
                itemIds: _selectedItemIds.toList(),
              );
              if (!success && mounted && vm.error != null) {
                Utils.showToast(
                  msg: vm.error!,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            };
          } else if (status == "RECEIVED") {
            buttonText = "Started";
            onButtonPressed = () async {
              if (deliveryId == null) return;
              final success = await vm.updateDeliveryStatus(
                deliveryId,
                "STARTED",
              );
              if (!success && mounted && vm.error != null) {
                Utils.showToast(
                  msg: vm.error!,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            };
          } else if (status == "STARTED") {
            buttonText = "Arrived";
            onButtonPressed = () async {
              if (deliveryId == null) return;
              final success = await vm.updateDeliveryStatus(
                deliveryId,
                "ARRIVED",
              );
              if (!success && mounted && vm.error != null) {
                Utils.showToast(
                  msg: vm.error!,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            };
          } else if (status == "ARRIVED") {
            buttonText = "Proceed to delivery note";
            onButtonPressed =
                () => Navigator.pushNamed(
                  context,
                  RouteNames.driverDeliveryNoteScreen,
                  arguments: args,
                );
          }

          return Column(
            children: [
              // Header Container (White background)
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Column(
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      displayAddress,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Products:   ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          totalQuantity,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Available Products:   ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          availableQuantity,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Gradient Background for List and Button
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFDECEE), Color(0xFFF6B7B7)],
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          itemCount: orderItems.length,
                          separatorBuilder:
                              (context, index) => Divider(
                                color: Colors.grey.shade300,
                                height: 24.h,
                                thickness: 1,
                              ),
                          itemBuilder: (context, index) {
                            final prod = orderItems[index];
                            final itemId = prod.id ?? "";
                            final prodName =
                                prod.product?.name ?? "Unknown Product";
                            final prodQty = prod.quantity?.toString() ?? "0";
                            final itemStatus = prod.itemStatus?.toUpperCase();
                            final isUnavailable =
                                itemStatus == "UNAVAILABLE";

                            // Determine if item is selected or disabled based on status
                            bool isChecked = false;
                            bool isDisabled = false;

                            if (isAssignedStatus) {
                              if (isUnavailable) {
                                isDisabled = true;
                                isChecked = false;
                              } else {
                                // APPROVED / Available item: selectable, initially unchecked
                                isDisabled = false;
                                isChecked = _selectedItemIds.contains(itemId);
                              }
                            } else {
                              // In subsequent steps (RECEIVED, STARTED, ARRIVED):
                              final isPicked =
                                  itemStatus == "PICKED" ||
                                  itemStatus == "DELIVERED" ||
                                  (itemStatus != "NOT_PICKED" &&
                                      !isUnavailable &&
                                      prod.pickedAt != null);

                              if (isPicked) {
                                isChecked = true;
                                isDisabled = false;
                              } else {
                                isChecked = false;
                                isDisabled = true;
                              }
                            }

                            return Opacity(
                              opacity: isDisabled ? 0.45 : 1.0,
                              child: GestureDetector(
                                onTap:
                                    (isAssignedStatus && !isDisabled)
                                        ? () {
                                          setState(() {
                                            if (_selectedItemIds.contains(
                                              itemId,
                                            )) {
                                              _selectedItemIds.remove(itemId);
                                            } else {
                                              _selectedItemIds.add(itemId);
                                            }
                                          });
                                        }
                                        : null,
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    children: [
                                      // Index
                                      SizedBox(
                                        width: 28.w,
                                        child: Text(
                                          "${index + 1}.",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color:
                                                isDisabled
                                                    ? Colors.grey
                                                    : Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4.w),

                                      // Checkbox
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        width: 24.w,
                                        height: 24.w,
                                        decoration: BoxDecoration(
                                          color:
                                              isDisabled
                                                  ? Colors.grey.shade200
                                                  : (isChecked
                                                      ? const Color(0xFFE20613)
                                                      : Colors.white),
                                          border: Border.all(
                                            color:
                                                isDisabled
                                                    ? Colors.grey.shade400
                                                    : const Color(0xFFE20613),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5.r,
                                          ),
                                        ),
                                        child:
                                            isChecked
                                                ? Icon(
                                                  Icons.check,
                                                  size: 16.sp,
                                                  color: Colors.white,
                                                )
                                                : null,
                                      ),
                                      SizedBox(width: 10.w),

                                      // Product Name
                                      Expanded(
                                        child: Text(
                                          prodName,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color:
                                                isDisabled
                                                    ? Colors.grey.shade600
                                                    : Colors.black87,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                isUnavailable
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                            decorationColor:
                                                Colors.grey.shade600,
                                            decorationThickness: 2,
                                          ),
                                        ),
                                      ),

                                      // Quantity
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            prodQty,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color:
                                                  isDisabled
                                                      ? Colors.grey
                                                      : Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  isUnavailable
                                                      ? TextDecoration.lineThrough
                                                      : TextDecoration.none,
                                              decorationColor:
                                                  Colors.grey.shade600,
                                              decorationThickness: 2,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "Pcs",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color:
                                                  isDisabled
                                                      ? Colors.grey
                                                      : Colors.black38,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Action Button
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        color: Colors.transparent,
                        child: SafeArea(
                          top: false,
                          child: SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: vm.isLoading ? null : onButtonPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFED5E68),
                                disabledBackgroundColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                elevation: 0,
                              ),
                              child:
                                  vm.isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        buttonText,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
