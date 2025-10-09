import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: BarChart(
        BarChartData(
          maxY: 1000, // max value for Y axis
          barTouchData: BarTouchData(enabled: false),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
            ),
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32.w,
                interval: 200,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.authBodyTextColor,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
                  return Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      days[value.toInt()],
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.authBodyTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: [
            _bar(0, 800, const Color(0xFFE20614)), // Odd - Red
            _bar(1, 600, const Color(0xFFF5C3C6)), // Even - Light Pink
            _bar(2, 1000, const Color(0xFFE20614)), // Odd - Red
            _bar(3, 700, const Color(0xFFF5C3C6)), // Even - Light Pink
            _bar(4, 600, const Color(0xFFE20614)), // Odd - Red
            _bar(5, 900, const Color(0xFFF5C3C6)), // Even - Light Pink
            _bar(6, 750, const Color(0xFFE20614)), // Odd - Red
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 32.w, // Set bar width to 32.w
          color: color,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }
}