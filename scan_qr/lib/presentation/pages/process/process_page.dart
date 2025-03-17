import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/core/utils/helpers/exit_confirmation.dart';
import 'package:scan_qr/presentation/blocs/process/process_bloc.dart';
import 'package:scan_qr/presentation/blocs/process/process_event.dart';
import 'package:scan_qr/presentation/blocs/process/process_state.dart';
import 'package:scan_qr/presentation/pages/process/process_component_widgets.dart';
import 'package:scan_qr/presentation/widgets/navigation/navbar_widget.dart';
import 'package:scan_qr/presentation/widgets/scaffolds/general_scaffold.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProcessBloc>().add(ProcessInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationHelper.wrapWithExitConfirmation(
      isRootScreen: true,
      context: context,
      child: GeneralScreenScaffold(
        isSubScreen: false,
        showBackButton: true,
        title: const Text(
          'PROCESSING',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
        body: BlocBuilder<ProcessBloc, ProcessState>(
          builder: (context, state) {
            if (state is ProcessLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProcessLoaded) {
              return ProcessComponentWidgets.buildProcessingTable(context);
            } else if (state is ProcessError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        bottomNavigationBar: const NavbarWidget(),
      ),
    );
  }
}
