import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/home/home_screen_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constant/app_colors.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        final apiData = provider.getLastSevenDaysOrdersModel?.data;

        /// --------------- Loading Indicator ----------------------------------
        if (provider.isLoading) {
          return Container(
            height: 200.h,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }

        if (apiData == null) {
          return Center(
            child: Text(
              "No Weekly Orders Found",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        /// ---------------- Create Last 7 Days List ----------------
        final now = DateTime.now();
        final last7Days = List.generate(7, (index) {
          return DateTime(now.year, now.month, now.day - (6 - index));
        });

        /// ----------------- Convert API Data To Map -------------------------
        final Map<String, double> apiDataMap = {};

        for (var item in apiData) {
          if (item.plainDate != null && item.totalQuantity != null) {
            final parsedDate = DateTime.tryParse(item.plainDate!);
            if (parsedDate != null) {
              final key =
                  "${parsedDate.year}-${parsedDate.month}-${parsedDate.day}";
              apiDataMap[key] = item.totalQuantity!.toDouble();
            }
          }
        }

        /// -------------------- Merge With Default 7 Days --------------------
        final mergedData =
            last7Days.map((date) {
              final key = "${date.year}-${date.month}-${date.day}";
              return apiDataMap[key] ?? 0.0;
            }).toList();

        /// ---------------- Calculate maxY --------------------------
        double maxY =
            mergedData.isNotEmpty
                ? mergedData.reduce((a, b) => a > b ? a : b)
                : 0;

        maxY = maxY == 0 ? 100 : maxY * 1.2;

        return Container(
          height: 200.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barTouchData: BarTouchData(enabled: false),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                getDrawingHorizontalLine:
                    (value) =>
                        FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32.w,
                    interval: maxY / 5,
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
                      if (value.toInt() < last7Days.length) {
                        final date = last7Days[value.toInt()];
                        return Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            _getDayFromDate(date),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.authBodyTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(7, (index) {
                final y = mergedData[index];
                final color =
                    index % 2 == 0
                        ? AppColors.primaryColor
                        : const Color(0xFFfac8cb);

                return _bar(index, y, color);
              }),
            ),
          ),
        );
      },
    );
  }

  /// --------------------------- Get Day Label From Date ----------------------
  String _getDayFromDate(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'MON';
      case DateTime.tuesday:
        return 'TUE';
      case DateTime.wednesday:
        return 'WED';
      case DateTime.thursday:
        return 'THU';
      case DateTime.friday:
        return 'FRI';
      case DateTime.saturday:
        return 'SAT';
      case DateTime.sunday:
        return 'SUN';
      default:
        return '';
    }
  }

  /// -------- Create Bar ----------
  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 32.w,
          color: color,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }
}
