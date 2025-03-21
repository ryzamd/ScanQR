import 'package:scan_qr/domain/repositories/scan_repository.dart';

class SaveScanDataUseCase {
  final ScanRepository repository;

  SaveScanDataUseCase(this.repository);

  Future<String> execute(List<List<String>> scannedItems) {
    return repository.saveScannedData(scannedItems);
  }
}