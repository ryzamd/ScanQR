// file: lib/data/models/process_record_model.dart
import 'package:scan_qr/domain/entities/process_record.dart';

class ProcessRecordModel {
  final String sn;
  final String supplier;
  final String time;
  final String date;
  final String status;
  final String total;

  ProcessRecordModel({
    required this.sn,
    required this.supplier,
    required this.time,
    required this.date,
    required this.status,
    required this.total,
  });

  ProcessRecord toEntity() {
    return ProcessRecord(
      sn: sn,
      supplier: supplier,
      time: time,
      date: date,
      status: status,
      total: total,
    );
  }

  factory ProcessRecordModel.fromEntity(ProcessRecord record) {
    return ProcessRecordModel(
      sn: record.sn,
      supplier: record.supplier,
      time: record.time,
      date: record.date,
      status: record.status,
      total: record.total,
    );
  }
}
