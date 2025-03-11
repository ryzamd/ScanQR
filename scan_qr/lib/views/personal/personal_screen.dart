import 'package:flutter/material.dart';
import 'package:scan_qr/routes/routes_system.dart';
import 'package:scan_qr/templates/navbars/navbar_widget.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          0,
        ), // Hide the app bar but keep status bar
        child: AppBar(backgroundColor: Colors.white, elevation: 0),
      ),
      body: Column(
        children: [
          // Profile header with avatar and username
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/zucca-logo.png', // Replace with actual avatar
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey.shade700,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Name
                const Text(
                  'Justin',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                // Username
                Text(
                  'justinisfine123',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 350,
            child: Column(
              spacing: 10,
              children: [
                // Menu items
                _buildMenuItem(
                  context: context,
                  icon: Icons.person_pin_rounded,
                  title: 'Profile',
                  isSelected: true,
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.personalProfile);
                  },
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.notifications_outlined,
                  title: 'Notification',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.info_outline,
                  title: 'Information',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      AppRouter.login, 
                      (route) => false
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.redAccent,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
      minLeadingWidth: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}