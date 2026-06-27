import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';
import 'package:hmlegends/presentation/view/drivier_flow/driver_home/viewmodel/driver_branch_detail_viewmodel.dart';

class DriverBranchDetailScreen extends StatefulWidget {
  const DriverBranchDetailScreen({super.key});

  @override
  State<DriverBranchDetailScreen> createState() => _DriverBranchDetailScreenState();
}

class _DriverBranchDetailScreenState extends State<DriverBranchDetailScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final deliveryId = args?["deliveryId"];
      if (deliveryId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<DriverBranchDetailViewModel>(context, listen: false).fetchSingleDelivery(deliveryId);
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
      appBar: const CustomAppBar(notificationCount: 0, backArrow: "true", isDriver: true),
      body: Consumer<DriverBranchDetailViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null) {
            return Center(child: Text(vm.error!));
          }

          final orderItems = vm.deliveryData?.order?.orderItems ?? [];
          final displayName = vm.deliveryData?.order?.user?.name ?? name;
          final displayAddress = vm.deliveryData?.order?.user?.address ?? address;
          final displayProductsCount = vm.deliveryData?.order?.totalQuantity?.toString() ?? productsCount;
          final status = vm.deliveryData?.status?.toUpperCase() ?? "ASSIGNED";

          String buttonText = "Delivery Done";
          VoidCallback? onButtonPressed;

          if (status == "ASSIGNED") {
            buttonText = "Received";
            onButtonPressed = () => vm.updateDeliveryStatus(args?["deliveryId"], "RECEIVED");
          } else if (status == "RECEIVED") {
            buttonText = "Started";
            onButtonPressed = () => vm.updateDeliveryStatus(args?["deliveryId"], "STARTED");
          } else if (status == "STARTED") {
            buttonText = "Arrived";
            onButtonPressed = () => vm.updateDeliveryStatus(args?["deliveryId"], "ARRIVED");
          } else if (status == "ARRIVED") {
            buttonText = "Proceed to delivery note";
            onButtonPressed = () => Navigator.pushNamed(
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
                      displayProductsCount,
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
                        final prodName = prod.product?.name ?? "Unknown Product";
                        final prodQty = prod.quantity?.toString() ?? "0";

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 28.w,
                                child: Text(
                                  "${index + 1}.",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  prodName,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      prodQty,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Pcs",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        );
                      },
                    ),
                  ),

                  // Start Delivery Button
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
                          onPressed: onButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED5E68),
                            disabledBackgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            elevation: 0,
                          ),
                          child: vm.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
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
