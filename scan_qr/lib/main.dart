import 'package:flutter/material.dart';
import 'package:scan_qr/flavors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlavorConfig.instance.appTitle,
      theme: FlavorConfig.instance.theme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(FlavorConfig.instance.name),
        ),
        body: Center(
          child: Text('${FlavorConfig.instance.appTitle} Content'),
        ),
      ),
    );
  }
}
