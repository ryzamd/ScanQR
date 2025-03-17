import 'package:flutter/material.dart';
import 'package:scan_qr/core/utils/helpers/exit_confirmation.dart';
import 'package:scan_qr/presentation/pages/dashboard/dashboard_component_widget.dart';
import 'package:scan_qr/presentation/widgets/navigation/navbar_widget.dart';
import 'package:scan_qr/presentation/widgets/scaffolds/general_scaffold.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return ExitConfirmationHelper.wrapWithExitConfirmation(
      context: context, 
      isRootScreen: true,
      child: GeneralScreenScaffold(
        title: const Text(
          "DASH BOARD",
          style: TextStyle(
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
        bottomNavigationBar: const NavbarWidget(),
      )
    );
  }
}