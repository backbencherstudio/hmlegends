import 'package:flutter/material.dart';
import 'package:hmlegends/presentation/view_model/parent/bottom_nav_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../widget/custom_app_bar.dart';
import '../../home/screen/home_screen.dart';
import 'custom_bottom_nav_bar.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {


    final List<Widget> pages = const [
      HomeScreen(),
      Center(child: Text('Stock Screen')),
      Center(child: Text('Order Screen')),
      Center(child: Text('Invoice Screen')),
    ];

    final titles = ['Home', 'Stock', 'Order', 'Invoice'];

    return Consumer<BottomNavViewModel>(
      builder: (context,nav,child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8F8),
          appBar: CustomAppBar(
                title: titles[nav.currentIndex],
                profileImage: 'assets/profile.jpg',
                notificationCount: 5,
              ),
          body: pages[nav.currentIndex],
          bottomNavigationBar: const CustomBottomNavBar(),
        );
      }
    );
  }
}