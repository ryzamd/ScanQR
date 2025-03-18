// file: lib/data/datasources/local/barcode_scanner_source.dart
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerSource {
  static const MethodChannel _channel = MethodChannel('com.example.scan_qr');
  static final List<String> scannedBarcodes = [];

  void initializeScannerListener(Function(String) onScanned) {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "scannerKeyPressed") {
        String scannedData = call.arguments.toString();
        onScanned(scannedData);
      }
    });
  }

  Future<bool> toggleTorch(
    MobileScannerController controller,
    bool currentState,
  ) async {
    await controller.toggleTorch();
    return !currentState;
  }

  Future<void> switchCamera(MobileScannerController controller) async {
    await controller.switchCamera();
  }

  Future<void> resetScanner(MobileScannerController controller) async {
    await controller.stop();
    await controller.start();
  }

  String processBarcode(BarcodeCapture barcodeCapture) {
    if (barcodeCapture.barcodes.isNotEmpty) {
      final barcode = barcodeCapture.barcodes.first;
      return barcode.rawValue ?? "";
    }
    return "";
  }
}
