import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/orders/presentation/view/screens/my_orders.dart';
import 'package:provider/provider.dart';
import '../../admin_flow/admin/profile/screen/head_office_profile_screen.dart';
import '../../admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import '../Invoice/presentation/Invoice_screen.dart';
import '../home/home_screen.dart';
import '../orders/presentation/view/orders_screen.dart';
import 'bottom_nav_bar.dart';

class BranchParentScreen extends StatefulWidget {
  const BranchParentScreen({super.key});

  @override
  State<BranchParentScreen> createState() => _BranchParentScreenState();
}

class _BranchParentScreenState extends State<BranchParentScreen> {

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addPersistentFrameCallback((_) async {
  //     await context.read<ChangePasswordProvider>().adminCheckMe();
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BranchHomeScreen(),
      MyOrders(),
      InvoiceScreen(),
      HeadOfficeProfileScreen(),
    ];

    return Consumer<BottomNavViewModel>(
      builder: (context, nav, child) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: pages[nav.currentIndex],
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
