import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/orders/presentation/view/screens/my_orders.dart';
import 'package:provider/provider.dart';
import '../../admin_flow/admin/profile/screen/head_office_profile_screen.dart';
import '../../admin_flow/view_model/parent/bottom_nav_viewmodel.dart';
import '../Invoice/presentation/branch_invoice_screen.dart';
import '../home/home_screen.dart';
import 'bottom_nav_bar.dart';

class BranchParentScreen extends StatefulWidget {
  const BranchParentScreen({super.key});

  @override
  State<BranchParentScreen> createState() => _BranchParentScreenState();
}

class _BranchParentScreenState extends State<BranchParentScreen> {
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BottomNavViewModel>().updateIndex(0);
      }
    });
  }

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
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (nav.currentIndex != 0) {
              nav.updateIndex(0);
              return;
            }

            final now = DateTime.now();
            final backButtonHasNotBeenPressedOrMaxTimeHasPassed =
                _lastPressedAt == null ||
                now.difference(_lastPressedAt!) > const Duration(seconds: 2);

            if (backButtonHasNotBeenPressedOrMaxTimeHasPassed) {
              _lastPressedAt = now;
              Utils.showToast(
                msg: "Press back again to exit the app",
                backgroundColor: Colors.black,
                textColor: Colors.white,
              );
              return;
            }

            await SystemNavigator.pop();
          },
          child: Scaffold(
            backgroundColor: AppColors.bgColor,
            body: pages[nav.currentIndex],
            bottomNavigationBar: const BottomNavBar(),
          ),
        );
      },
    );
  }
}
