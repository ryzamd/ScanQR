import 'package:flutter/material.dart';
import 'package:scan_qr/templates/dialogs/custom_dialogs.dart';

class ProcessComponentWidgets {
  static Widget buildProcessingTable(BuildContext context) {
    return ProcessingTableWidget();
  }
}

class ProcessingTableWidget extends StatefulWidget {
  const ProcessingTableWidget({super.key});

  @override
  State<ProcessingTableWidget> createState() => _ProcessingTableWidgetState();
}

class _ProcessingTableWidgetState extends State<ProcessingTableWidget> {
  final List<ProcessRecord> _records = [
    ProcessRecord(sn: "1", supplier: "PRIMO", time: "17:11:00 PM", date: "02/28/25", status: "SUCCESS",  total: "50"),
    ProcessRecord(sn: "2", supplier: "PRIMO", time: "17:11:00 PM", date: "02/28/25", status: "FAILED",   total: "50"),
    ProcessRecord(sn: "3", supplier: "PRIMO", time: "17:11:00 PM", date: "02/28/25", status: "PENDDING", total: "50"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          _buildTableHeader(context),
          const SizedBox(height: 3),
          Expanded(child: _buildTableContent(context)),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnRatios = [0.1, 0.15, 0.15, 0.15, 0.25, 0.2];

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Table(
        columnWidths: {
          for (int i = 0; i < columnRatios.length; i++)
            i: FixedColumnWidth(screenWidth * columnRatios[i]),
        },
        children: [
          TableRow(
            children: [
              _buildHeaderCell("SN"),
              _buildHeaderCell("Sup"),
              _buildHeaderCell("Time"),
              _buildHeaderCell("Date"),
              _buildHeaderCell("Status"),
              _buildHeaderCell("Total"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent(BuildContext context) {
    return ListView.separated(
      itemCount: _records.length,
      separatorBuilder: (context, index) => const SizedBox(height: 3),
      padding: const EdgeInsets.only(bottom: 5),
      itemBuilder: (context, index) {
        final record = _records[index];
        final bgColor = index % 2 == 0 ? Colors.grey[600]! : Colors.grey[700]!;
        return _buildTableRow(context, record, bgColor);
      },
    );
  }

  Widget _buildTableRow(BuildContext context, ProcessRecord record, Color bgColor) {
    Color statusColor;
    if (record.status == "SUCCESS") {
      statusColor = Colors.green;
    } else if (record.status == "FAILED") {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final columnRatios = [0.1, 0.15, 0.15, 0.15, 0.25, 0.2];

    return GestureDetector(
      onLongPress: () => _handleRowTap(context, record),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Table(
          columnWidths: {
            for (int i = 0; i < columnRatios.length; i++)
              i: FixedColumnWidth(screenWidth * columnRatios[i]),
          },
          children: [
            TableRow(
              children: [
                _buildValueCell(record.sn),
                _buildValueCell(record.supplier),
                _buildValueCell(record.time),
                _buildValueCell(record.date),
                _buildStatusCell(record.status, statusColor),
                _buildValueCell(record.total),
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
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildValueCell(String value) {
    return Text(
      value,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatusCell(String status, Color color) {
    return Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }

  void _handleRowTap(BuildContext context, ProcessRecord record) {
    switch (record.status) {
      case "SUCCESS":
        CustomDialog.success(
          context: context,
          title: "Success",
          message: "Bạn có chắc chắn muốn xóa tất cả dữ liệu đã quét?",
          confirmLabel: null,
          cancelLabel: null,
          onConfirm: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) {
              CustomDialog.notice(
                context: context,
                title: "Success",
                message: "Đã chuyển đến kho thành công !!",
                isHasCancelButton: false,
                confirmLabel: null,
                cancelLabel: null,
              );
            }
          },
        );
        break;
      case "PENDDING":
        CustomDialog.notice(
          context: context,
          title: "Notice",
          message: "Đang đợi duyệt!",
          isHasCancelButton: false,
          confirmLabel: null,
          cancelLabel: null,
        );
        break;
      case "FAILED":
        CustomDialog.warning(
          context: context,
          title: "Warning",
          message: "Bạn có chắc chắn muốn xóa tất cả dữ liệu đã quét?",
          confirmLabel: null,
          cancelLabel: null,
        );
        break;
      default:
    }
  }
}

class ProcessRecord {
  final String sn;
  final String supplier;
  final String time;
  final String date;
  final String status;
  final String total;

  ProcessRecord({
    required this.sn,
    required this.supplier,
    required this.time,
    required this.date,
    required this.status,
    required this.total,
  });
}
