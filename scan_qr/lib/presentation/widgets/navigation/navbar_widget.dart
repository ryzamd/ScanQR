import 'package:flutter/material.dart';
import 'package:scan_qr/presentation/routes/app_router.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  int _getSelectedIndex(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    switch (routeName) {
      case AppRouter.process:
        return 0;
      case AppRouter.dashboard:
        return 1;
      case AppRouter.personal:
        return 2;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);
    return NavigationBar(
      height: 45,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      backgroundColor: Colors.grey[400],
      destinations: const [
        NavigationDestination(icon: Icon(Icons.article), label: ''),
        NavigationDestination(icon: Icon(Icons.home), label: ''),
        NavigationDestination(icon: Icon(Icons.person), label: ''),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (int value) {
        if (value == 0 && ModalRoute.of(context)?.settings.name != AppRouter.process) {
          debugPrint('Setting route name: ${ModalRoute.of(context)?.settings.name}');
          Navigator.pushReplacementNamed(context, AppRouter.process);
        } else if (value == 1 &&
            ModalRoute.of(context)?.settings.name != AppRouter.dashboard) {
              debugPrint('Setting route name: ${ModalRoute.of(context)?.settings.name}');
          Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        } else if (value == 2 &&
            ModalRoute.of(context)?.settings.name != AppRouter.personal) {
              debugPrint('Setting route name: ${ModalRoute.of(context)?.settings.name}');
          Navigator.pushReplacementNamed(context, AppRouter.personal);
        }
      },
    );
  }
}