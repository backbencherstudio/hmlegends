import 'package:flutter/material.dart';
import 'package:hmlegends/core/route/route_names.dart';
import 'package:provider/provider.dart';
import '../driver_provider/branch_product_provider.dart';

class DeliverySummeryScreen extends StatelessWidget {
  const DeliverySummeryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BranchProductProvider>(context);

    // Filter selected items only
    final items = provider.products
        .where((p) => p.isSelected == true)
        .map((p) => _DeliveredItem(p.name, p.quantity))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFF1F2),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, RouteNames.driverBranchParentScreen),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        ),
        title: const Text(
          "Delivery Summary",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.notifications_none,
                  size: 28,
                  color: Colors.black87,
                ),
              ),
              Positioned(
                right: 10,
                top: -2,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '12',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              "assets/images/wahab.png",
              height: 34,
              width: 34,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // White info card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Branch Name-01",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1F2C),
                  ),
                ),
                const SizedBox(height: 12),
                _infoRow(
                  label: "Total Products:",
                  value: "${items.length}",
                ),
                const SizedBox(height: 10),
                _infoRow(
                  icon: Icons.access_time_rounded,
                  label: "Completed at:",
                  value: "10:25:48",
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Section header
          Row(
            children: [
              Image.asset("assets/images/delivery.png", height: 30),
              const SizedBox(width: 8),
              const Text(
                "Items Delivered",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE6E6E9)),
          const SizedBox(height: 8),

          // List of delivered items
          if (items.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No items selected for delivery."),
              ),
            )
          else
            ...items.map((e) => _DeliveredTile(item: e)),

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _infoRow({
    IconData? icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        if (icon != null) Icon(icon, size: 18, color: const Color(0xFFEF4444)),
        if (icon != null) const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A4C56),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF1D1F2C),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DeliveredItem {
  final String name;
  final int count;
  const _DeliveredItem(this.name, this.count);
}

class _DeliveredTile extends StatelessWidget {
  final _DeliveredItem item;
  const _DeliveredTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Red rounded square with check
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFEF4444), width: 2),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.check, size: 16, color: Color(0xFFEF4444)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                fontSize: 14.5,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            "(${item.count})",
            style: const TextStyle(
              fontSize: 14.5,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
