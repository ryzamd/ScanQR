import 'package:scan_qr/data/datasources/local/scan_data_local_source.dart';
import 'package:scan_qr/domain/entities/scanned_item.dart';
import 'package:scan_qr/domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanDataLocalSource localSource;

  ScanRepositoryImpl(this.localSource);

  @override
  Future<String> saveScannedData(List<List<String>> scannedItems) {
    return localSource.saveScannedData(scannedItems);
  }

  @override
  Future<List<ScannedItem>> getScannedItems() async {
    // Since in the original code there's no method to get the latest file,
    // we would need to implement a way to get the path to the most recent file
    // or store this information somewhere.
    // For now, we'll return an empty list
    return [];
  }
}
