import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:provider/provider.dart';
import '../../widget/custom_app_bar.dart';
import '../driver_provider/branch_product_provider.dart';
import '../model_view/delivery_provideer_Admin.dart';

class DriverBranchDetailScreen extends StatefulWidget {
  const DriverBranchDetailScreen({super.key});

  @override
  State<DriverBranchDetailScreen> createState() =>
      _DriverBranchDetailScreenState();
}

class _DriverBranchDetailScreenState extends State<DriverBranchDetailScreen> {
  bool deliveryStarted = false;
  List<bool> selectedItems = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<BranchProductProvider>(
        context,
        listen: false,
      );
      await provider.fetchBranchProducts();

      for (var p in provider.products) {
        p.isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        notificationCount: 12,
        profileImage: "assets/images/wahab.png",
        backArrow: "back_arrow",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Branch info container
              Center(
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Text(
                        "Branch Name-01",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "4140 Parker Rd. Allentown, New Mexico 31134",
                        style: TextStyle(
                          color: const Color(0xff4A4C56),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Consumer<DeliveryProviderAdmin>(
                        builder: (context, provider, _) {
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Total Products :  ",
                                  style: TextStyle(
                                    color: const Color(0xff4A4C56),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${provider.singleDeliveryModelDriver?.data?.order?.totalQuantity ?? 0}",
                                  style: TextStyle(
                                    color: const Color(0xff1D1F2C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Consumer<DeliveryProviderAdmin>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final orderItems = provider
                      .singleDeliveryModelDriver
                      ?.data
                      ?.order
                      ?.orderItems;

                  if (orderItems == null || orderItems.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No products found."),
                      ),
                    );
                  }

                  // Initialize selection list if empty
                  if (selectedItems.length != orderItems.length) {
                    selectedItems = List<bool>.filled(orderItems.length, false);
                  }

                  return ListView.builder(
                    itemCount: orderItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final orderItem = orderItems[index];
                      final isSelected = selectedItems[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: const BoxDecoration(
                            color: Color(0xffFFF6F7),
                          ),
                          child: Row(
                            children: [
                              Text("${index + 1}."),
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: const Color(0xffE20613),
                                value: isSelected,
                                onChanged: (val) {
                                  if (!deliveryStarted) {
                                    setState(() {
                                      selectedItems[index] = val!;
                                    });
                                  }
                                },
                              ),
                              Expanded(
                                child: Text(
                                  orderItem.product?.name ?? "Unknown",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    decoration: (deliveryStarted && isSelected)
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: (deliveryStarted && isSelected)
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Text("${orderItem.quantity} pcs"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 8.h),

              Builder(
                builder: (context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Consumer<DeliveryProviderAdmin>(
                      builder: (context, provider, _) {
                        final orderItems = provider
                            .singleDeliveryModelDriver
                            ?.data
                            ?.order
                            ?.orderItems;

                        // Enable button only if all items are selected
                        bool allSelected =
                            selectedItems.isNotEmpty &&
                            selectedItems.every((e) => e);

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: allSelected
                                ? const Color(0xffE20613)
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                            ),
                          ),
                          onPressed: allSelected
                              ? () async {
                                  if (!deliveryStarted) {
                                    setState(() {
                                      deliveryStarted = true;
                                    });
                                    await provider.deliveryReceivedAdmin(
                                      provider
                                              .singleDeliveryModelDriver
                                              ?.data!
                                              .id ??
                                          "",
                                    );
                                    await provider.setDeliveryId(
                                      provider.deliveryId ?? "",
                                    );
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.confirmDeliveryScreen,
                                    );
                                  }
                                }
                              : null,
                          child: Text(
                            deliveryStarted
                                ? "Proceed to Delivery Note"
                                : "Start Delivery",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
