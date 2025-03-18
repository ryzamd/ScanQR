import 'package:scan_qr/data/models/outbound_record_model.dart';
import 'package:scan_qr/domain/entities/outbound_record.dart';
import 'package:scan_qr/domain/repositories/outbound_repository.dart';

class OutboundRepositoryImpl implements OutboundRepository {
  @override
  List<OutboundRecord> getRecords(String selectedType) {
    List<OutboundRecordModel> records = [];

    if (selectedType == "SUBCONTRACTOR") {
      records = [
        OutboundRecordModel(id: "SC1", time: "9:00 AM", date: "01/01/2023", quantity: "50/50", status: "Pending"),
        OutboundRecordModel(id: "SC2", time: "9:30 AM", date: "01/01/2023", quantity: "100/100", status: "Completed"),
      ];
    } else if (selectedType == "WORK SHOP") {
      records = [
        OutboundRecordModel(id: "WS1", time: "10:00 AM", date: "01/01/2023", quantity: "30/100", status: "Pending"),
        OutboundRecordModel(id: "WS2", time: "10:30 AM", date: "01/01/2023", quantity: "100/100", status: "Completed"),
      ];
    }

    return records.map((model) => model.toEntity()).toList();
  }
}