import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/dependency_injection/injection.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_bloc.dart';
import 'package:scan_qr/presentation/pages/auth/login_page.dart';
import 'package:scan_qr/presentation/pages/auth/register_page.dart';
import 'package:scan_qr/presentation/pages/dashboard/dashboard_page.dart';
import 'package:scan_qr/presentation/pages/dashboard/outbound_component_widgets.dart';
import 'package:scan_qr/presentation/pages/dashboard/outbound_page.dart';
import 'package:scan_qr/presentation/pages/dashboard/outbound_category_scan_page.dart';
import 'package:scan_qr/presentation/pages/dashboard/temporary_page.dart';
import 'package:scan_qr/presentation/pages/personal/personal_page.dart';
import 'package:scan_qr/presentation/pages/personal/personal_profile_page.dart';
import 'package:scan_qr/presentation/pages/process/process_page.dart';

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
          builder: (_) => const LoginPage(),
        );
      case register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterPage(),
        );
      case dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DashboardPage(),
        );
      case process:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProcessPage(),
        );
      case personal:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PersonalPage(),
        );
      case personalProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PersonalProfilePage(),
        );
      case outbound:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OutboundPage(),
        );
      case temporary:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider<ScanBloc>(
                create: (context) => getIt<ScanBloc>(),
                child: const TemporaryPage(),
              ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
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
          builder:
              (context) => OutBoundComponentWidgets.buildSelectType(context),
        );
      case outboundScan:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (context) => OutboundCategoryScanPage(
                  key: args['key'],
                  onCameraToggle: args['onCameraToggle'],
                  onClearData: args['onClearData'],
                ),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => OutboundCategoryScanPage(
                onCameraToggle: () {},
                onClearData: () {},
              ),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => OutBoundComponentWidgets.buildSelectType(context),
        );
    }
  }
}
