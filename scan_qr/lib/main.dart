import 'package:flutter/material.dart';
import 'package:scan_qr/routes/routes_system.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Brunches-RoughSlanted',
        primarySwatch: Colors.blue,
      ),
    );
  }
}