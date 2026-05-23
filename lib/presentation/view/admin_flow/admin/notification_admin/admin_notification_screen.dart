import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:provider/provider.dart';

import '../../view_model/notification_admin/admin_notification_provider.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
  String _selectedPeriod = 'Today';
  final ScrollController _scrollController = ScrollController();

  static const _periodMap = {
    'Today': 'today',
    'This Week': 'week',
    'This Month': 'month',
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<AdminNotificationProvider>().getAdminNotification(period: 'today');
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<AdminNotificationProvider>();
      if (provider.hasMore && !provider.isLoadingMore) {
        provider.loadMore();
      }
    }
  }

  String _timeAgo(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      if (_selectedPeriod == 'This Month') {
        final d = dt.day.toString().padLeft(2, '0');
        final m = dt.month.toString().padLeft(2, '0');
        return '$d/$m/${dt.year}';
      }
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes} min ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
      } else {
        return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
      }
    } catch (_) {
      return '';
    }
  }

  String _avatarUrl(String? avatar) {
    if (avatar == null || avatar.isEmpty) return '';
    return '${ApiEndpoints.baseUrl}/public/storage/avatar/$avatar';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminNotificationProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: const Color(0xFFFFF5F5),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20.sp,
            color: const Color(0xFF1D1F2C),
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1F2C),
          ),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriod,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF1D1F2C),
              ),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1D1F2C),
              ),
              dropdownColor: const Color(0xFFFFF5F5),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedPeriod = value);
                provider.changePeriod(_periodMap[value]!);
              },
              items: _periodMap.keys
                  .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),

      body: Column(
        children: [
          // Mark all as read bar
          if (notifications.isNotEmpty)
            Container(
              width: double.infinity,
              color: const Color(0xFFFFF5F5),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => provider.markAllAsRead(),
                  child: Text(
                    'Mark all as read',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFFB5050F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

          // List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : notifications.isEmpty
                    ? Center(
                        child: Text(
                          'No notifications for $_selectedPeriod',
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: notifications.length +
                            (provider.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == notifications.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          }

                          final n = notifications[index];
                          final isRead = n.readAt != null;
                          final imgUrl = _avatarUrl(n.sender?.avatar);

                          return GestureDetector(
                            onTap: () {
                              if (!isRead && n.id != null) {
                                provider.markAsRead(n.id!);
                              }
                            },
                            child: Container(
                              color: isRead
                                  ? Colors.white
                                  : const Color(0xFFFFEDED),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor:
                                        const Color(0xFFE0E0E0),
                                    child: imgUrl.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              imgUrl,
                                              width: 40.r,
                                              height: 40.r,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (_, child,
                                                      progress) =>
                                                  progress == null
                                                      ? child
                                                      : Icon(Icons.person,
                                                          size: 20.sp,
                                                          color: Colors.grey),
                                              errorBuilder: (_, __, ___) =>
                                                  Icon(Icons.person,
                                                      size: 20.sp,
                                                      color: Colors.grey),
                                            ),
                                          )
                                        : Icon(Icons.person,
                                            size: 20.sp,
                                            color: Colors.grey),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          n.notificationEvent?.text ?? '',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade800,
                                            height: 1.4,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          _timeAgo(n.createdAt),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
