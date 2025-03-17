import 'package:flutter/material.dart';
import 'package:scan_qr/core/utils/helpers/exit_confirmation.dart';
import 'package:scan_qr/presentation/widgets/navigation/navbar_widget.dart';
import 'package:scan_qr/presentation/routes/app_router.dart';
import 'package:scan_qr/presentation/widgets/scaffolds/general_scaffold.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationHelper.wrapWithExitConfirmation(
      isRootScreen: true,
      context: context,
      child: GeneralScreenScaffold(
        isSubScreen: false,
        title: const Text(
          "PROFILE",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                children: [
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
                          'assets/images/zucca-logo.png',
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
                  const Text(
                    'Justin',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
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
                children: [
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
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const NavbarWidget(),
      ),
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
      leading: Icon(icon, color: Colors.redAccent, size: 24),
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