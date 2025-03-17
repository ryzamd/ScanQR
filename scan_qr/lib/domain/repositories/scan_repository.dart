import 'package:scan_qr/domain/entities/scanned_item.dart';

abstract class ScanRepository {
  Future<String> saveScannedData(List<List<String>> scannedItems);
  Future<List<ScannedItem>> getScannedItems();
}
