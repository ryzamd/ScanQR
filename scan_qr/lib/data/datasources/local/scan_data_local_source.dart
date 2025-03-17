import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:scan_qr/data/models/scanned_item_model.dart';

class ScanDataLocalSource {
  Future<String> saveScannedData(List<List<String>> scannedItems) async {
    try {
      final List<Map<String, dynamic>> jsonData =
          scannedItems.map((item) {
            return {
              'code': item[0],
              'status': item[1],
              'quantity': item[2],
              'total': item[3],
            };
          }).toList();

      final String jsonContent = jsonEncode({
        'scanTime': DateTime.now().toIso8601String(),
        'scannedItems': jsonData,
      });

      final String directoryPath = '/sdcard/Download/data_scanned';

      final Directory directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final String timestamp = DateFormat(
        'yyyyMMdd_HHmmss',
      ).format(DateTime.now());
      final String filename = 'scan_data_$timestamp.json';

      final String filePath = '$directoryPath/$filename';

      final File file = File(filePath);
      await file.writeAsString(jsonContent);

      debugPrint('Scan data successfully saved to: $filePath');
      debugPrint('Saved content: $jsonContent');

      return filePath;
    } catch (e) {
      debugPrint('Error saving scan data: $e');
      return '';
    }
  }

  Future<List<ScannedItemModel>> getScannedItems(String filePath) async {
    try {
      final File file = File(filePath);
      if (!file.existsSync()) {
        return [];
      }

      final String jsonContent = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonContent);

      final List<dynamic> itemsJson = data['scannedItems'];
      return itemsJson.map((item) => ScannedItemModel.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error reading scan data: $e');
      return [];
    }
  }
}
