import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../../../core/constant/asset_path.dart';
import '../../widget/simple_appbar.dart';

class OrdersScreen extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onPrefixTap;

  const OrdersScreen({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onSuffixTap,
    this.onPrefixTap,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int totalSelected = 0;
  final List<bool> selectedList = List.generate(6, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: SimpleAppbar(
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
        title: 'Place Order',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total items Selected: $totalSelected',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: totalSelected > 0
                        ? () => _showSubmitDialog(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: totalSelected > 0
                          ? Colors.red
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: const Text(
                      'Submit Order',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: const Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  prefixIcon: GestureDetector(
                    onTap: widget.onPrefixTap,
                    child: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 22.w,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: widget.onSuffixTap,
                    child: Icon(
                      Icons.tune,
                      color: Colors.grey.shade600,
                      size: 22.w,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: selectedList.length,
                itemBuilder: (context, index) {
                  return periChickenWrapCard(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Center(
          child: Text(
            'Can’t edit after submission',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ),
        content: Text(
          'Are you sure you want to submit\n                today’s order?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          Row(spacing: 20,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showSuccessDialog(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(backgroundColor: Colors.greenAccent.shade200,
                      content: Text('Submitted $totalSelected items successfully!',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffE20613),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:  EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                ),
                child: const Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffE9E9EA), // Grey background
                  foregroundColor: Colors.black, // Black text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        actions: [
         GestureDetector(
             onTap: (){Navigator.pushNamed(context, RouteNames.myOrders);},
             child: Image.asset('assets/images/successful.png',scale: 2,))
        ],
      ),
    );
  }
  Widget periChickenWrapCard(BuildContext context, int index) {
    int quantity = 10;
    const int stock = 120;
    final String productName = 'Peri Chicken Wrap $index';
    const String imageUrl = 'assets/images/food_burger.png';

    void decrementQuantity(StateSetter setState) {
      setState(() {
        if (quantity > 1) quantity--;
      });
    }

    void incrementQuantity(StateSetter setState) {
      setState(() {
        if (quantity < stock) quantity++;
      });
    }

    return StatefulBuilder(
      builder: (context, setState) {
        final isSelected = selectedList[index];

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        imageUrl,
                        width: 100,
                        height: 115,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12.0),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stock: $stock pcs',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'In Stock',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ✅ Quantity & Confirm Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => decrementQuantity(setState),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.remove,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        '$quantity',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => incrementQuantity(setState),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedList[index] =
                                          !selectedList[index];
                                    });
                                    this.setState(() {
                                      totalSelected = selectedList
                                          .where((e) => e)
                                          .length;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? Colors.green
                                        : Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                  ),
                                  child: Text(
                                    isSelected ? 'Selected' : 'Confirm',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}