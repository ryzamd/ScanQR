import 'package:flutter/material.dart';
import 'package:scan_qr/routes/routes_system.dart';
import 'out_bound_business.dart';

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
    final records = _selectedItem.isNotEmpty
        ? OutBoundBusiness.getRecords(_selectedItem)
        : <OutBoundRecord>[];

    return Container(
      color: Colors.grey.shade300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDropdownRow(context),

          if (_selectedItem.isNotEmpty)
            _buildTableSection(records),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Future<void> _showMenuDropdown(BuildContext context) async {
    final RenderBox arrowIcon =
        _arrowKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset offset = arrowIcon.localToGlobal(Offset.zero, ancestor: overlay);

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
      items: items.map((String item) {
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
    }
  }

  Widget _buildTableSection(List<OutBoundRecord> records) {
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
        columnWidths: const {
          0: FixedColumnWidth(30),
          1: FixedColumnWidth(65),
          2: FixedColumnWidth(90),
          3: FixedColumnWidth(70),
          4: FixedColumnWidth(70),
        },
        children: [
          TableRow(
            children: [
              _buildHeaderCell("ID"),
              _buildHeaderCell("TIME"),
              _buildHeaderCell("DATE"),
              _buildHeaderCell("QTY"),
              _buildHeaderCell("TOTAL"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, OutBoundRecord record) {
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
            0: FixedColumnWidth(30),
            1: FixedColumnWidth(65),
            2: FixedColumnWidth(90),
            3: FixedColumnWidth(70),
            4: FixedColumnWidth(70),
          },
          children: [
            TableRow(
              children: [
                _buildValueCell(record.id),
                _buildValueCell(record.time),
                _buildValueCell(record.date),
                _buildValueCell(record.quantity),
                _buildValueCell(record.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildValueCell(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}
