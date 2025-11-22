import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:provider/provider.dart';
import '../../admin_flow/admin/profile/screen/head_office_profile_screen.dart';
import '../../admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import '../Invoice/presentation/Invoice_screen.dart';
import '../home/home_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';
import 'bottom_nav_bar.dart';

class BranchParentScreen extends StatelessWidget {
  const BranchParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BranchHomeScreen(),
      OrdersScreen(),
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
