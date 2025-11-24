import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../../core/constant/asset_path.dart';
import '../../widget/custom_app_bar.dart';

class BranchHomeScreen extends StatefulWidget {
  const BranchHomeScreen({super.key});

  @override
  State<BranchHomeScreen> createState() => _BranchHomeScreenState();
}

class _BranchHomeScreenState extends State<BranchHomeScreen> {
  String _currentBar = "first";

  bool _orderPlaced = false;

  void _onPlaceOrderPressed() {
    setState(() {
      _orderPlaced = true;
      _currentBar = "second";
    });
  }

  void _onLockAccountPressed() {
    setState(() {
      _currentBar = "third";
    });
  }

  Widget _getCurrentTopBar() {
    switch (_currentBar) {
      case "second":
        return const AlignTopBarSecond();
      case "third":
        return const AlignTopBarThird();
      default:
        return const AlignTopBarFirst();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            bottom: -60,
            child: SizedBox(
              height: 300.h,
              child: Image.asset('assets/images/foodss.png'),
            ),
          ),

          Positioned(
              bottom: 220,
              right: 150,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 30.w, height: 30.h)),
          Positioned(
              bottom: 200,
              right: 200,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 20.w, height: 20.h)),
          Positioned(
              bottom: 260,
              right: 280,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 20.w, height: 20.h)),
          Positioned(
              bottom: 230,
              right: 320,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 12.w, height: 12.h)),
          Positioned(
              bottom: 250,
              right: 360,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 12.w, height: 12.h)),
          Positioned(
              bottom: 240,
              right: 390,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 12.w, height: 12.h)),
          Positioned(
              bottom: 240,
              left: 390,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 15.w, height: 15.h)),
          Positioned(
              bottom: 260,
              left: 370,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 20.w, height: 20.h)),
          Positioned(
              bottom: 260,
              left: 320,
              child: SvgPicture.asset('assets/icons/Star 2.svg',
                  width: 17.w, height: 17.h)),

          Align(
            alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: 10.h,),
                  Text('Branch Name – (BR001)',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                  SizedBox(height: 10.h,),
                  _getCurrentTopBar(),
                  SizedBox(height: 40.h,),
                  Row(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      Column(
                        spacing: 10,
                        children: [
                          GestureDetector(
                            onTap: _onPlaceOrderPressed,
                            child: CustomFeatureBox(
                              imagePath: 'assets/icons/first_box.png',
                              text: 'Place Order',
                              isDisabled: _orderPlaced,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, RouteNames.invoiceScreen);
                            },
                            child: CustomFeatureBox(
                              imagePath: 'assets/icons/third_box.png',
                              text: 'Invoices',
                            ),
                          ),
                        ],
                      ),
                       Column(
                        spacing: 10,
                        children: [
                          GestureDetector(
                            onTap:(){
                              Navigator.pushNamed(context, RouteNames.ordersScreen);
                            },
                            child: CustomFeatureBox(
                              imagePath: 'assets/icons/second_box.png',
                              text: 'My orders',
                            ),
                          ),
                          CustomFeatureBox(
                            imagePath: 'assets/icons/fourth_box.png',
                            text: 'My Delivery',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}

class AlignTopBarFirst extends StatelessWidget {
  const AlignTopBarFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      child: Container(
        width: double.infinity,
        height: 40.h,
        color: const Color(0xff5BB450),
        child: Center(
          child: Text(
            'You can place today’s order. Time left: 2h 30m.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class AlignTopBarSecond extends StatelessWidget {
  const AlignTopBarSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        height: 40.h,
        color: const Color(0xffA5A5AB),
        child: Center(
          child: Text(
            'You have already placed today’s order.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class AlignTopBarThird extends StatelessWidget {
  const AlignTopBarThird({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        height: 45.h,
        color: const Color(0xffFAD33E),
        child: Center(
          child: Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/Vector.png', scale: 3),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      'Your account is locked due to unpaid invoices.\n',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: const Color(0xff777980),
                      ),
                    ),
                    TextSpan(
                      text: 'Please clear ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: const Color(0xff777980),
                      ),
                    ),
                    TextSpan(
                      text: 'payment.',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xff777980),
                        decorationThickness: 2,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFeatureBox extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isDisabled;

  const CustomFeatureBox({
    super.key,
    required this.imagePath,
    required this.text,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 110.h,
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey.shade300 : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, scale: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
