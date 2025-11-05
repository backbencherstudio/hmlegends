import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:provider/provider.dart';
import '../../widget/custom_app_bar.dart';
import '../driver_provider/branch_product_provider.dart';

class DriverBranchDetailScreen extends StatefulWidget {
  const DriverBranchDetailScreen({super.key});

  @override
  State<DriverBranchDetailScreen> createState() =>
      _DriverBranchDetailScreenState();
}

class _DriverBranchDetailScreenState extends State<DriverBranchDetailScreen> {
  bool deliveryStarted = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider =
      Provider.of<BranchProductProvider>(context, listen: false);
      await provider.fetchBranchProducts();

      for (var p in provider.products) {
        p.isSelected = false;
      }
      provider.notifyListeners();
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    Consumer<BranchProductProvider>(
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
                                text: "${provider.products.length}",
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

            Consumer<BranchProductProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (provider.products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No products found."),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    final bool isSelected = product.isSelected ?? false;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration:
                      const BoxDecoration(color: Color(0xffFFF6F7)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("${index + 1}."),
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: const Color(0xffE20613),
                                value: isSelected,
                                onChanged: (val) {
                                  if (!deliveryStarted) {
                                    provider.toggleProductSelection(index);
                                  }
                                },
                              ),
                              Expanded(
                                child: Text(
                                  product.name,
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
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${product.quantity} ",
                                      style: TextStyle(
                                        color: const Color(0xff4A4C56),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: product.unit,
                                      style: TextStyle(
                                        color: const Color(0xff777980),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            SizedBox(height: 10.h),

            Consumer<BranchProductProvider>(
              builder: (context, provider, _) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE20613),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                    onPressed: () {
                      final hasSelected = provider.products
                          .any((p) => p.isSelected == true);

                      if (!hasSelected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select at least one item."),
                          ),
                        );
                        return;
                      }

                      if (!deliveryStarted) {
                        setState(() {
                          deliveryStarted = true;
                        });
                      } else {
                        Navigator.pushNamed(
                          context,
                          RouteNames.confirmDeliveryScreen,
                        );
                      }
                    },
                    child: Text(
                      deliveryStarted
                          ? "Proceed to Delivery Note"
                          : "Start Delivery",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
