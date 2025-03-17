import 'package:flutter/material.dart';
import 'package:scan_qr/views/dashboard/dash_board_screen.dart';
import 'package:scan_qr/views/dashboard/outbound/out_bound_screen.dart';
import 'package:scan_qr/views/dashboard/outbound/out_bound_component_widgets.dart';
import 'package:scan_qr/views/dashboard/outbound/outbound_category_scan/outbound_category_scan_screen.dart';
import 'package:scan_qr/views/dashboard/temporary/temporary_screen.dart';
import 'package:scan_qr/views/auth/login/login_screen.dart';
import 'package:scan_qr/views/auth/register/register_screen.dart';
import 'package:scan_qr/views/personal/personal_screen.dart';
import 'package:scan_qr/views/personal/personal_profile_screen.dart';
import 'package:scan_qr/views/process/process_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String process = '/process';
  static const String personal = '/personal';
  static const String personalProfile = '/personal/profile';
  static const String outbound = '/outbound';
  static const String temporary = '/temporary';
  
  static const String outboundMain = '/outbound-main';
  static const String outboundScan = '/outbound-scan';
  
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );
      case dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DashBoardScreen(),
        );
      case process:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProcessingScreen(),
        );
      case personal:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PersonalScreen(),
        );
      case personalProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PersonalProfileScreen(),
        );
      case outbound:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OutBoundScreen(),
        );
      case temporary:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TemporaryScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
  
  static Route<dynamic>? onGenerateOutboundRoute(RouteSettings settings) {
    switch (settings.name) {
      case outboundMain:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => OutBoundComponentWidgets.buildSelectType(context),
        );
      case outboundScan:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => OutboundCategoryScanScreen(
              key: args['key'],
              onCameraToggle: args['onCameraToggle'],
              onClearData: args['onClearData'],
            ),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => OutboundCategoryScanScreen(
            onCameraToggle: () {},
            onClearData: () {},
          ),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => OutBoundComponentWidgets.buildSelectType(context),
        );
    }
  }
}