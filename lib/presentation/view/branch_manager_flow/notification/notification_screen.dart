// import 'package:flutter/material.dart';
//
// class NotificationItem {
//   final String message;
//   final String timeAgo;
//   final DateTime date;
//   final bool isNew;
//
//   NotificationItem({
//     required this.message,
//     required this.timeAgo,
//     required this.date,
//     this.isNew = false,
//   });
// }
//
// class NotificationTile extends StatelessWidget {
//   final NotificationItem item;
//   final Color highlightColor = const Color(0xFFFEE8E8); // Light pink for new items
//
//   const NotificationTile({
//     super.key,
//     required this.item,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: item.isNew ? highlightColor : Colors.transparent,
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Avatar
//            Padding(
//             padding: EdgeInsets.fromLTRB(16.0, 8.0, 12.0, 8.0),
//             child: ClipOval(
//               child: Image.asset('assets/images/panda.jpeg',scale: 5,),
//             ),
//           ),
//           // Text Content
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.message,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade800,
//                       fontWeight: FontWeight.w500,
//                       height: 1.4,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     item.timeAgo,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   final List<NotificationItem> allNotifications = [
//     NotificationItem(
//       message: 'Your invoice-0123 is ready to pay bill.',
//       timeAgo: '2 hours ago',
//       date: DateTime.now().subtract(const Duration(hours: 2)),
//       isNew: true,
//     ),
//     NotificationItem(
//       message: 'Your today\'s order is handed over for delivering to van-4',
//       timeAgo: '5 hours ago',
//       date: DateTime.now().subtract(const Duration(hours: 5)),
//       isNew: true,
//     ),
//     NotificationItem(
//       message: 'Your today\'s order is approved.',
//       timeAgo: '1 day ago',
//       date: DateTime.now().subtract(const Duration(days: 1)),
//       isNew: true,
//     ),
//     NotificationItem(
//       message: 'Your account has been unlocked by head office.',
//       timeAgo: '3 days ago',
//       date: DateTime.now().subtract(const Duration(days: 3)),
//       isNew: true,
//     ),
//     NotificationItem(
//       message: 'Your account has been locked by head office due to unpaid invoice-0123.',
//       timeAgo: '10 days ago',
//       date: DateTime.now().subtract(const Duration(days: 10)),
//       isNew: false,
//     ),
//     NotificationItem(
//       message: 'Your monthly report is ready for review.',
//       timeAgo: '25 days ago',
//       date: DateTime.now().subtract(const Duration(days: 25)),
//       isNew: false,
//     ),
//     NotificationItem(
//       message: 'New policy update regarding remote work.',
//       timeAgo: '2 months ago',
//       date: DateTime.now().subtract(const Duration(days: 60)),
//       isNew: false,
//     ),
//     NotificationItem(
//       message: 'Holiday schedule published.',
//       timeAgo: '3 months ago',
//       date: DateTime.now().subtract(const Duration(days: 90)),
//       isNew: false,
//     ),
//   ];
//
//   String _filter = 'Today';
//   final List<String> filters = ['Today', 'This Week', 'This Year'];
//
//   List<NotificationItem> get filteredNotifications {
//     final now = DateTime.now();
//
//     if (_filter == 'Today') {
//       return allNotifications
//           .where((n) =>
//       n.date.year == now.year &&
//           n.date.month == now.month &&
//           n.date.day == now.day)
//           .toList();
//     } else if (_filter == 'This Week') {
//       final weekAgo = now.subtract(const Duration(days: 7));
//       return allNotifications.where((n) => n.date.isAfter(weekAgo)).toList();
//     } else if (_filter == 'This Year') {
//       return allNotifications.where((n) => n.date.year == now.year).toList();
//     } else {
//       return allNotifications;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final notifications = filteredNotifications;
//
//     return Scaffold(
//       backgroundColor: const Color(0xffFFF6F7),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         titleSpacing: 0,
//         title: Padding(
//           padding: const EdgeInsets.only(left: 10.0),
//           child: Row(
//             children: [
//               // Back Icon
//               IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, size: 20),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               const SizedBox(width: 8),
//               const Expanded(
//                 child: Text(
//                   'Notifications',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               // Filter Dropdown
//               DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: _filter,
//                   icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _filter = newValue!;
//                     });
//                   },
//                   items: filters.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(width: 16.0),
//             ],
//           ),
//         ),
//       ),
//       body: notifications.isEmpty
//           ? const Center(
//         child: Text(
//           'No notifications found',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//       )
//           : ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           return NotificationTile(item: notifications[index]);
//         },
//       ),
//     );
//   }
// }
