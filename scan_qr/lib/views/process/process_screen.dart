import 'package:flutter/material.dart';
import 'package:scan_qr/templates/general_scaffords/general_scafford_screen.dart';
import 'package:scan_qr/templates/navbars/navbar_widget.dart';
import 'process_component_widgets.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    return GeneralScreenScaffold(
      isSubScreen: false,
      showBackButton: true,
      title: const Text(
        'PROCESSING',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
      ],
      body: ProcessComponentWidgets.buildProcessingTable(context),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}