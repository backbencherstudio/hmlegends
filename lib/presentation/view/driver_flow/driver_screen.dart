import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/presentation/view/driver_flow/model_view/driver_profile_screen_provider.dart';
import 'package:hmlegends/presentation/view/driver_flow/tracking/tracking_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/route/route_names.dart';
import '../widget/custom_app_bar.dart';
import 'model_view/delivery_provideer_Admin.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DeliveryProviderAdmin>(
        context,
        listen: false,
      );
      provider.getAllDeliveryAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<DriverProfileScreenProvider>(context);
    final data = profileProvider.checkMeModelDriver?.data;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return Scaffold(
          appBar: CustomAppBar(
            profileImage: data?.avatar,
            notificationCount: 4,
          ),

          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Consumer<DeliveryProviderAdmin>(
                  builder: (context, provider, child) {
                    final deliveries =
                        provider.allDeliveryModelDriver?.data ?? [];

                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (deliveries.isEmpty) {
                      return const Center(child: Text("No deliveries found"));
                    }

                    return ListView.builder(
                      itemCount: deliveries.length,
                      itemBuilder: (context, index) {
                        final delivery = deliveries[index];
                        return _branchInfoCard(
                          branchName: delivery.user?.city ?? 'Unknown City',
                          address: delivery.user?.address ?? 'No Address',
                          totalProducts: delivery.totalQuantity ?? 0,
                          deliveryId: delivery.delivery?.id ?? '',
                          provider: provider,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget getter for BranchInfoCard
  Widget _branchInfoCard({
    required String branchName,
    required String address,
    required int totalProducts,
    required String deliveryId,
    required DeliveryProviderAdmin provider,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (deliveryId.isNotEmpty) {
              await provider.getSingleDeliveryAdmin(deliveryId);
              Navigator.pushNamed(context, RouteNames.driverBranseDetailScreen);
            } else {
              Utils.showToast(
                msg: 'No delivery found',
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          },
          child: Container(
            width: double.infinity,
            //  height: 120.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6F7),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branchName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                // Address Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18.sp,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // Total Products
                RichText(
                  text: TextSpan(
                    text: 'Total Products: ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: totalProducts.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<TrackingProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        provider.setDeliveryId(deliveryId);

                        Navigator.pushNamed(context, RouteNames.trackingScreen);
                      },
                      child: Text("Start your Tracking"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
