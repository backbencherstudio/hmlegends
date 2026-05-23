import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../view_model/parent/bottom_nav_viewmodel.dart';
import '../../home/screen/head_office_home_screen.dart';
import '../../invoice/screen/head_office_invoice_screen.dart';
import '../../order/screen/order_summary_screen.dart';
import '../../stock/screen/stock_screen.dart';
import '../widget/custom_bottom_nav_bar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BottomNavViewModel>().reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HeadOfficeHomeScreen(),
      StockScreen(fromBottomNav: true),
      OrderSummaryScreen(fromBottomNav: true),
      HeadOfficeInvoiceScreen(fromBottomNav: true),
    ];

    return Consumer<BottomNavViewModel>(
      builder: (context, nav, child) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: pages[nav.currentIndex],
          bottomNavigationBar: const CustomBottomNavBar(),
        );
      },
    );
  }
}
