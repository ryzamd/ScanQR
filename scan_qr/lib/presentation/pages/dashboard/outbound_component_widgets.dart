import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/domain/entities/outbound_record.dart';
import 'package:scan_qr/presentation/blocs/outbound/outbound_bloc.dart';
import 'package:scan_qr/presentation/blocs/outbound/outbound_event.dart';
import 'package:scan_qr/presentation/blocs/outbound/outbound_state.dart';
import 'package:scan_qr/presentation/routes/app_router.dart';

class OutBoundComponentWidgets {
  static Widget buildSelectType(BuildContext context) {
    return const CustomMenuWidget();
  }
}

class CustomMenuWidget extends StatefulWidget {
  const CustomMenuWidget({super.key});

  @override
  State<CustomMenuWidget> createState() => _CustomMenuWidgetState();
}

class _CustomMenuWidgetState extends State<CustomMenuWidget> {
  final GlobalKey _arrowKey = GlobalKey();
  String _selectedItem = "";
  final List<String> items = ["SUBCONTRACTOR", "WORK SHOP"];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutboundBloc, OutboundState>(
      builder: (context, state) {
        List<OutboundRecord> records = [];

        if (state is OutboundLoaded) {
          records = state.records;
          if (_selectedItem.isEmpty && state.selectedType.isNotEmpty) {
            _selectedItem = state.selectedType;
          }
        }

        return Container(
          color: Colors.grey.shade300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDropdownRow(context),

              if (_selectedItem.isNotEmpty)
                _buildTableSection(context, records),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownRow(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Padding(
        // Compensate for any visual offset
        padding: EdgeInsets.only(left: 24.0), // Adjust this value as needed
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedItem.isEmpty ? "SELECT TYPE" : _selectedItem,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                key: _arrowKey,
                onTap: () async {
                  await _showMenuDropdown(context);
                },
                child: const Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMenuDropdown(BuildContext context) async {
    final RenderBox arrowIcon =
        _arrowKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset offset = arrowIcon.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + arrowIcon.size.height,
      overlay.size.width - offset.dx - arrowIcon.size.width,
      overlay.size.height - offset.dy,
    );

    final selected = await showMenu<String>(
      color: Colors.grey[300],
      context: context,
      position: position,
      items:
          items.map((String item) {
            return PopupMenuItem(
              value: item,
              child: Text(item, textAlign: TextAlign.center),
            );
          }).toList(),
    );

    if (selected != null) {
      setState(() {
        _selectedItem = selected;
      });

      context.read<OutboundBloc>().add(OutboundTypeSelected(selected));
    }
  }

  Widget _buildTableSection(
    BuildContext context,
    List<OutboundRecord> records,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 12, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(),
          const SizedBox(height: 8),
          ...records.map((record) => _buildTableRow(context, record)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: {
          0: FractionColumnWidth(0.1),
          1: FractionColumnWidth(0.2),
          2: FractionColumnWidth(0.3),
          3: FractionColumnWidth(0.2),
          4: FractionColumnWidth(0.2),
        },
        children: [
          TableRow(
            children: [
              _HeaderCell("ID"),
              _HeaderCell("TIME"),
              _HeaderCell("DATE"),
              _HeaderCell("QTY"),
              _HeaderCell("TOTAL"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, OutboundRecord record) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.outboundScan);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Table(
          columnWidths: const {
            0: FractionColumnWidth(0.1),
            1: FractionColumnWidth(0.2),
            2: FractionColumnWidth(0.3),
            3: FractionColumnWidth(0.2),
            4: FractionColumnWidth(0.2),
          },
          children: [
            TableRow(
              children: [
                _ValueCell(record.id),
                _ValueCell(record.time),
                _ValueCell(record.date),
                _ValueCell(record.quantity),
                _ValueCell(record.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String title;

  const _HeaderCell(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String value;

  const _ValueCell(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}
