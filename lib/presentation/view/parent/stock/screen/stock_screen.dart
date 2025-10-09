import 'package:flutter/material.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarTwo(
          title: 'Stock Management',
          profileImage: AssetPaths.personIcon,
          notificationCount: 4,
        onNotificationTap: (){}, colorMain: Colors.white, colorSpace: Colors.white,
      ),
      body: Center(
        child: Text('Hello'),
      ),
    );
  }
}
