import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_delivery/view_model/delivery_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/asset_path.dart';
import '../../../../widget/custom_app_bar_2.dart';
import '../widget/assign_driver_sheet.dart';
import '../widget/branch_card.dart';

class ManageDeliveryScreen extends StatefulWidget {
  const ManageDeliveryScreen({super.key});

  @override
  State<ManageDeliveryScreen> createState() => _ManageDeliveryScreenState();
}

class _ManageDeliveryScreenState extends State<ManageDeliveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDeliveries();
    });
  }

  Future<void> _loadDeliveries() async {
    await context.read<DeliveryProvider>().getAllDeliveries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBarTwo(
        title: 'Manage Delivery',
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        colorMain: Colors.white,
        colorSpace: Colors.white,
        onBackTap: () => Navigator.pop(context),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDeliveries,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Consumer<DeliveryProvider>(
            builder: (context, provider, _) {
              // Show loading indicator while data is being fetched
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Check if data is null or empty
              if (provider.allDeliveriesModel?.data == null ||
                  provider.allDeliveriesModel!.data!.isEmpty) {
                return const Center(child: Text('No deliveries available'));
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: provider.allDeliveriesModel!.data!.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  var branch = provider.allDeliveriesModel!.data![index];

                  return BranchCard(
                    name: branch.user?.name ?? "N/A",
                    totalProducts: branch.totalQuantity ?? 0,
                    address: branch.user?.address ?? "N/A",
                    onAssignTap: () {
                      // Open bottom sheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                        ),
                        builder:
                            (_) => AssignDriverSheet(
                              onSend: () {
                                context
                                    .read<DeliveryProvider>()
                                    .getAllDrivers();
                              },
                            ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
