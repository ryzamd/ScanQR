import 'package:scan_qr/domain/entities/outbound_record.dart';

abstract class OutboundRepository {
  List<OutboundRecord> getRecords(String selectedType);
}
