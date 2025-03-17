// file: lib/domain/usecases/scan_barcode_usecase.dart
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/core/constants/key_codes.dart';

class ScanBarcodeUseCase {
  static const MethodChannel _channel = MethodChannel('com.example.scan_qr');
  final Function(String)? onBarcodeScanned;

  ScanBarcodeUseCase({this.onBarcodeScanned});

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

  bool isScannerButtonPressed(KeyEvent event) {
    return event.logicalKey.keyId == KeycodeConstants.scannerKeyCode;
  }

  Future<void> triggerScan(
    MobileScannerController controller,
    Function(String) onScanned,
  ) async {
    await controller.start();
  }
}
