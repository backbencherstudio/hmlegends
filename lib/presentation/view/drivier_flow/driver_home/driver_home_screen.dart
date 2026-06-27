import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar.dart';
import 'package:hmlegends/presentation/view/drivier_flow/driver_home/viewmodel/driver_home_viewmodel.dart';
import 'widgets/driver_branch_card.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DriverHomeViewModel>(context, listen: false).fetchDeliveries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(notificationCount: 0, isDriver: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDECEE), 
              Color(0xFFF6B7B7),
            ],
          ),
        ),
        child: Consumer<DriverHomeViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text(vm.error!));
            }
            if (vm.deliveries.isEmpty) {
              return const Center(child: Text("No deliveries available"));
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: vm.deliveries.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = vm.deliveries[index];
                final name = item.user?.name ?? "Unknown Branch";
                final address = item.user?.address ?? "Unknown Address";
                final productsCount = item.totalQuantity?.toString() ?? "0";

                return InkWell(
                  onTap: () {
                    final status = item.delivery?.status;
                    final isCompleted = status == "COMPLETED" || status == "DELIVERED";
                    
                    Navigator.pushNamed(
                      context,
                      isCompleted 
                          ? RouteNames.deliverySummeryScreen 
                          : RouteNames.driverBranseDetailScreen,
                      arguments: {
                        "name": name,
                        "address": address,
                        "products": productsCount,
                        "deliveryId": item.delivery?.id,
                        "orderId": item.id,
                      },
                    );
                  },
                  child: BranchCard(
                    name: name,
                    address: address,
                    products: productsCount,
                    backgroundColor: Colors.white,
                    status: item.delivery?.status,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

