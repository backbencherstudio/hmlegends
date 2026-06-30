import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BranchCard extends StatelessWidget {
  final String name;
  final String address;
  final String products;
  final Color backgroundColor;
  final String? status;

  const BranchCard({
    super.key,
    required this.name,
    required this.address,
    required this.products,
    required this.backgroundColor,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 22.sp,
                color: Colors.black54,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                'Total Products:   ',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                products,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (status != null) ...[
                Spacer(),
                _buildStatusWidget(status!),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusWidget(String statusStr) {
    bool isCompleted = statusStr.toUpperCase() == 'COMPLETED' || statusStr.toUpperCase() == 'DELIVERED';
    
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFFE31E24) : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.access_time_rounded,
            size: 14.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          _formatStatus(statusStr),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  String _formatStatus(String status) {
    String upper = status.toUpperCase();
    if (upper == 'COMPLETED' || upper == 'DELIVERED') return "Delivery Done";
    if (status.isEmpty) return "";
    return status[0].toUpperCase() + status.substring(1).toLowerCase().replaceAll('_', ' ');
  }
}
