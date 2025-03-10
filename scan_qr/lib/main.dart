import 'package:flutter/material.dart';
import 'package:scan_qr/views/dashboard/dash_board_screen.dart';
import 'package:scan_qr/views/dashboard/outbound/out_bound_screen.dart';
import 'package:scan_qr/views/dashboard/temporary/temporary_screen.dart';
import 'package:scan_qr/views/login/login_screen.dart';
import 'package:scan_qr/views/personal/personal_screen.dart';
import 'package:scan_qr/views/process/process_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashBoardScreen(),
        '/process': (context) => const ProcessingScreen(),
        '/personal': (context) => const PersonalScreen(),
        '/outbound': (context) => const OutBoundScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/temporary') {
          return MaterialPageRoute(
            builder: (context) => const TemporaryScreen(),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Brunches-RoughSlanted',
        primarySwatch: Colors.blue,
      ),
    );
  }
}
