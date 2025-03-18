import 'package:scan_qr/domain/entities/outbound_record.dart';

class OutboundRecordModel {
  final String id;
  final String time;
  final String date;
  final String quantity;
  final String status;

  OutboundRecordModel({
    required this.id,
    required this.time,
    required this.date,
    required this.quantity,
    required this.status,
  });

  OutboundRecord toEntity() {
    return OutboundRecord(
      id: id,
      time: time,
      date: date,
      quantity: quantity,
      status: status,
    );
  }

  factory OutboundRecordModel.fromEntity(OutboundRecord record) {
    return OutboundRecordModel(
      id: record.id,
      time: record.time,
      date: record.date,
      quantity: record.quantity,
      status: record.status,
    );
  }
}
