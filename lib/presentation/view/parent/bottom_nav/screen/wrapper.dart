import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/app_colors.dart';
import 'package:hmlegends/presentation/view/parent/stock/screen/stock_screen.dart';
import 'package:hmlegends/presentation/view_model/parent/bottom_nav_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../home/screen/home_screen.dart';
import '../widget/custom_bottom_nav_bar.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      HomeScreen(),
      StockScreen(),
      HomeScreen(),
      HomeScreen(),
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
