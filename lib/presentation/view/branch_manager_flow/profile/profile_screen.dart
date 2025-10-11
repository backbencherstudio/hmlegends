import 'package:flutter/material.dart';
import 'package:hmlegends/core/route/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          Column(spacing: 10,
            children: [
              SizedBox(height: 20,),
              Text(
                'Are you sure you want\n            to log out?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(spacing: 20,
                children: [

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xffE20613),
                      side:  BorderSide(color: Color(0xffE20613)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: const Text(
                      'Log me out',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      _showSubmitDialog(context);

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE20613),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: const Text('Stay logged in',   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile',style: TextStyle(fontWeight: FontWeight.w700),),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {

            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            const _ProfileHeader(),
            const SizedBox(height: 15),
            const _ProfileInfoTile(
              icon: Icons.phone_outlined,
              title: 'Phone Number',
              value: '+123-456-7890',
            ),
            Divider(indent: 15,
            endIndent: 15,
            color: Colors.grey.shade300,
            ),
            const _ProfileInfoTile(
              icon: Icons.mail_outline,
              title: 'Email',
              value: 'camwill056@gmail.com',
            ),  Divider(indent: 15,
              endIndent: 15,
              color: Colors.grey.shade300,
            ),
            const _ProfileInfoTile(
              icon: Icons.location_on_outlined,
              title: 'Address',
              value: '2715 Ash Dr. San Jose, South\nDakota 83475',
            ),  Divider(indent: 15,
              endIndent: 15,
              color: Colors.grey.shade300,
            ),
            _ProfileActionTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              isDestructive: true,
              onTap: () {Navigator.pushNamedAndRemoveUntil(context, RouteNames.changePassword, (route) => false);
              },
            ),  Divider(indent: 15,
              endIndent: 15,
              color: Colors.grey.shade300,
            ),
            _ProfileActionTile(
              icon: Icons.info_outline,
              title: 'Change info',
              isDestructive: true,
              onTap: () {Navigator.pushNamedAndRemoveUntil(context, RouteNames.changeInfo, (route) => false);},
            ),  Divider(indent: 15,
              endIndent: 15,
              color: Colors.grey.shade300,
            ),
            _ProfileActionTile(
              icon: Icons.logout,
              title: 'Log out',
              isDestructive: true,
              onTap: () {
                _showSubmitDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFE20613), // Primary red
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // User Avatar (Placeholder)
                ClipOval(
                  child: Image.asset(
                    'assets/images/panda.jpeg', scale:2.7,// Placeholder image
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
                // Camera/Edit Icon
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2)
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFFD32F2F),
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Name
            const Text(
              'Cameron Williamson',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Role/Title
            const Text(
              "Head of Legends's branch-02",
              style: TextStyle(
                color: Color(0xFFF0F0F0), // Lighter white/grey
                fontSize: 16,
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Component: Profile Information Tile (Phone, Email, Address) ---

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.black87,
            size: 24,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff1D1F2C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A4C56),
                    fontWeight: FontWeight.w400
                  ),
                  softWrap: true, // Allow address to wrap
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Component: Profile Action Tile (Change Password, Log out) ---

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color for the text (red if destructive, otherwise black)
    final textColor = isDestructive ? const Color(0xFFD32F2F) : Colors.black87;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Color(0xff4A4C56),
              size: 24,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
