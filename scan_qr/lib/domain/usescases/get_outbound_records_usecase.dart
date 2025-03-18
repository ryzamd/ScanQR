import 'package:scan_qr/domain/entities/outbound_record.dart';
import 'package:scan_qr/domain/repositories/outbound_repository.dart';

class GetOutboundRecordsUseCase {
  final OutboundRepository repository;

  GetOutboundRecordsUseCase(this.repository);

  List<OutboundRecord> execute(String selectedType) {
    return repository.getRecords(selectedType);
  }
}
