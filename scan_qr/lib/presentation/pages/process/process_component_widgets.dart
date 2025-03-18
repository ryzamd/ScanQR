import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/domain/entities/process_record.dart';
import 'package:scan_qr/presentation/blocs/process/process_bloc.dart';
import 'package:scan_qr/presentation/blocs/process/process_event.dart';
import 'package:scan_qr/presentation/blocs/process/process_state.dart';
import 'package:scan_qr/presentation/widgets/dialogs/custom_dialogs.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcessBloc, ProcessState>(
      builder: (context, state) {
        if (state is ProcessLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProcessLoaded) {
          final records = state.records;

          return Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                _buildTableHeader(context),
                const SizedBox(height: 3),
                Expanded(child: _buildTableContent(context, records)),
              ],
            ),
          );
        } else if (state is ProcessError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          // Initial state - trigger loading
          context.read<ProcessBloc>().add(ProcessInitialized());
          return const Center(child: CircularProgressIndicator());
        }
      },
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
        children: const [
          TableRow(
            children: [
              _HeaderCell("SN"),
              _HeaderCell("Sup"),
              _HeaderCell("Time"),
              _HeaderCell("Date"),
              _HeaderCell("Status"),
              _HeaderCell("Total"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent(BuildContext context, List<ProcessRecord> records) {
    return ListView.separated(
      itemCount: records.length,
      separatorBuilder: (context, index) => const SizedBox(height: 3),
      padding: const EdgeInsets.only(bottom: 5),
      itemBuilder: (context, index) {
        final record = records[index];
        final bgColor = index % 2 == 0 ? Colors.grey[600]! : Colors.grey[700]!;
        return _buildTableRow(context, record, bgColor);
      },
    );
  }

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
                _ValueCell(record.sn),
                _ValueCell(record.supplier),
                _ValueCell(record.time),
                _ValueCell(record.date),
                _StatusCell(record.status, statusColor),
                _ValueCell(record.total),
              ],
            ),
          ],
        ),
      ),
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

class _HeaderCell extends StatelessWidget {
  final String title;

  const _HeaderCell(this.title);

  @override
  Widget build(BuildContext context) {
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
}

class _ValueCell extends StatelessWidget {
  final String value;

  const _ValueCell(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}

class _StatusCell extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusCell(this.status, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}
