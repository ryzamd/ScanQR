import 'package:flutter/material.dart';
import 'package:scan_qr/templates/dialogs/custom_dialogs.dart';

class ProcessComponentWidgets {
  static Widget buildProcessingTable(BuildContext context) {
    return const ProcessingTableWidget();
  }
}

class ProcessingTableWidget extends StatefulWidget {
  const ProcessingTableWidget({super.key});

  @override
  State<ProcessingTableWidget> createState() => _ProcessingTableWidgetState();
}

class _ProcessingTableWidgetState extends State<ProcessingTableWidget> {
  // Danh sách dữ liệu cho bảng
  final List<ProcessRecord> _records = [
    ProcessRecord(
      sn: "1",
      supplier: "PRIMO",
      time: "17:11:00 PM",
      date: "02/28/25",
      status: "SUCCESS",
      total: "50",
    ),
    ProcessRecord(
      sn: "2",
      supplier: "PRIMO",
      time: "17:11:00 PM",
      date: "02/28/25",
      status: "FAILED",
      total: "50",
    ),
    ProcessRecord(
      sn: "3",
      supplier: "PRIMO",
      time: "17:11:00 PM",
      date: "02/28/25",
      status: "PENDDING",
      total: "50",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          // Header của bảng
          _buildTableHeader(),

          // Body của bảng
          SizedBox(height: 3),
          Expanded(child: _buildTableContent(context)),
        ],
      ),
    );
  }

  /// ---------------------------
  /// 1. Header của bảng
  /// ---------------------------
  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Table(
        columnWidths: const {
            0: FixedColumnWidth(40),
            1: FixedColumnWidth(50),
            2: FixedColumnWidth(70),
            3: FixedColumnWidth(60),
            4: FixedColumnWidth(80),
            5: FixedColumnWidth(60),
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

  /// ---------------------------
  /// 2. Content của bảng (ListView)
  /// ---------------------------
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

  /// ---------------------------
  /// 3. Dòng dữ liệu
  /// ---------------------------
  Widget _buildTableRow(
    BuildContext context,
    ProcessRecord record,
    Color bgColor,
  ) {
    Color statusColor;
    if (record.status == "SUCCESS") {
      statusColor = Colors.green;
    } else if (record.status == "FAILED") {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return GestureDetector(
      onLongPress: () => _handleRowTap(context, record),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5), // Bo góc 5px
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(30),
            1: FixedColumnWidth(50),
            2: FixedColumnWidth(70),
            3: FixedColumnWidth(60),
            4: FixedColumnWidth(80),
            5: FixedColumnWidth(50),
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

  /// ---------------------------
  /// 4. Cell helper
  /// ---------------------------
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
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatusCell(String status, Color color) {
    return Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }

  /// ---------------------------
  /// 5. Xử lý sự kiện khi click vào dòng
  /// ---------------------------
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
              // Kiểm tra xem context có còn khả dụng không
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
          onCancel: () {
            // Your cancel action here
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
          onConfirm: () {
            // Your confirm action here
          },
          onCancel: () {
            // Your cancel action here
          },
        );
        break;
      case "FAILED":
        CustomDialog.warning(
          context: context,
          title: "Warning",
          message: "Bạn có chắc chắn muốn xóa tất cả dữ liệu đã quét?",
          confirmLabel: null,
          cancelLabel: null,
          onConfirm: () {
            // Your confirm action here
          },
          onCancel: () {
            // Your cancel action here
          },
        );
        break;
      default:
    }
  }
}

/// ---------------------------
/// Model cho dữ liệu bảng
/// ---------------------------
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
