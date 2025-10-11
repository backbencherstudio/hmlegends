import 'package:flutter/material.dart';
import '../../../core/constant/asset_path.dart';
import '../widget/custom_app_bar.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        profileImage: AssetPaths.personIcon,
        notificationCount: 4,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BranchInfoCard(
            branchName: 'Branch Name-01',
            address: '4140 Parker Rd. Allentown, New Mexico 31134',
            totalProducts: 216,
          ),
        ],
      ),
    );
  }
}

class BranchInfoCard extends StatelessWidget {
  final String branchName;
  final String address;
  final int totalProducts;

  const BranchInfoCard({
    super.key,
    required this.branchName,
    required this.address,
    required this.totalProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEECEE), // Light pink background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch Name
          Text(
            branchName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Address Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Total Products
          RichText(
            text: TextSpan(
              text: 'Total Products: ',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: totalProducts.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
