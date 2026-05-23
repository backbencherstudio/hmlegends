import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:hmlegends/core/utlis/utils.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/branch_manager_flow/orders/viewmodel/get_all_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../admin_flow/view_model/profile/change_pass_provider.dart';
import '../../widget/custom_app_bar.dart';
import '../orders/viewmodel/create_order_viewmodel.dart';

class BranchHomeScreen extends StatefulWidget {
  const BranchHomeScreen({super.key});

  @override
  State<BranchHomeScreen> createState() => _BranchHomeScreenState();
}

class _BranchHomeScreenState extends State<BranchHomeScreen> {
  String _currentBar = "first";

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<ChangePasswordProvider>(context).adminCheckMe();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final orderVm = Provider.of<OrderViewmodel>(context);

    /// Automatically switch UI when API success
    if (orderVm.hasPlacedToday && _currentBar != "second") {
      _currentBar = "second";
    }
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: CustomAppBar(
        profileImage: data?.avatar,
        notificationCount: notificationProvider.unreadCount,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // FOOD IMAGE
          Positioned(
            bottom: -60,
            child: SizedBox(
              height: 300.h,
              child: Image.asset('assets/images/foodss.png'),
            ),
          ),

          // STARS
          ...[
            Positioned(bottom: 220, right: 150, child: _star(30)),
            Positioned(bottom: 200, right: 200, child: _star(20)),
            Positioned(bottom: 260, right: 280, child: _star(20)),
            Positioned(bottom: 230, right: 320, child: _star(12)),
            Positioned(bottom: 250, right: 360, child: _star(12)),
            Positioned(bottom: 240, right: 390, child: _star(12)),
            Positioned(bottom: 240, left: 390, child: _star(15)),
            Positioned(bottom: 260, left: 370, child: _star(20)),
            Positioned(bottom: 260, left: 320, child: _star(17)),
          ],

          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Branch Name – (BR001)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(height: 10.h),

                /// TOP BARS SWITCH
                _getTopBarWidget(orderVm),

                SizedBox(height: 40.h),

                /// BUTTON GRID
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Column(
                      spacing: 10,
                      children: [
                        GestureDetector(
                          onTap:
                              orderVm.isLoading
                                  ? null
                                  : () async {
                                    final res = await orderVm.placeOrder(
                                      productId:
                                          context
                                              .read<GetProductsViewmodel>()
                                              .products
                                              .first
                                              .id,
                                    );
                                    if (res.success) {
                                      Utils.showToast(
                                        msg: res.message,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                      );
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          RouteNames.ordersScreen,
                                        );
                                      }
                                    } else {
                                      Utils.showToast(
                                        msg: res.message,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                      );
                                    }
                                  },
                          child: CustomFeatureBox(
                            imagePath: 'assets/icons/first_box.png',
                            text: 'Place Order',
                            isDisabled: orderVm.hasPlacedToday,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.invoiceScreen,
                            );
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
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.myOrders,
                            );
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
            ),
          ),
        ],
      ),
    );
  }

  /// STAR widget helper
  Widget _star(double size) {
    return SvgPicture.asset(
      'assets/icons/Star 2.svg',
      width: size.w,
      height: size.h,
    );
  }

  /// Select which top bar to show
  Widget _getTopBarWidget(OrderViewmodel vm) {
    if (vm.hasPlacedToday) return const AlignTopBarSecond();
    if (_currentBar == "third") return const AlignTopBarThird();
    return const AlignTopBarFirst();
  }
}

class AlignTopBarFirst extends StatelessWidget {
  const AlignTopBarFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class AlignTopBarSecond extends StatelessWidget {
  const AlignTopBarSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class AlignTopBarThird extends StatelessWidget {
  const AlignTopBarThird({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    text: 'Your account is locked due to unpaid invoices.\n',
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
                      decorationColor: Color(0xff777980),
                      decorationThickness: 2,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
