import 'package:flutter/material.dart';
import 'package:scan_qr/templates/general_scaffords/general_scafford_screen.dart';
import 'package:scan_qr/templates/navbars/navbar_widget.dart';
import 'package:scan_qr/views/dashboard/dash_board_component_widget.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;

    return GeneralScreenScaffold(
      title: Text(
        "DASH BOARD",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      isSubScreen: false,
      showBackButton: false,
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardWidgets.buildHeader(context),

                const SizedBox(height: 24),

                DashboardWidgets.buildStatisticCards(context),

                const SizedBox(height: 24),

                DashboardWidgets.buildFeatureTable(context),
              ],
            ),
          ),
        ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
