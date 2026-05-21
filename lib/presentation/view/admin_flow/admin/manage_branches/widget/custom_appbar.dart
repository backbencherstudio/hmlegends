import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final IconData back;
  final IconData notification;
  final String img;

  const CustomAppbar({
    super.key,
    required this.title,
    required this.back,
    required this.img,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(back),
            ),
            Text(
              title,
              style: TextStyle(
                color: Color(0xff1D1F2C),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),

            Stack(
              clipBehavior: Clip.none,

              children: [
                Icon(notification, size: 25),
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text("12", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(width: 14.w),
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Image.asset(img, width: 40, height: 40, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
