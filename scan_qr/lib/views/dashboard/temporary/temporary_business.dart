import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/utilites/contants/key_code_constant.dart';

class TemporaryBusiness {
  static const MethodChannel _channel = MethodChannel('com.example.scan_qr');
  static Function(String)? onBarcodeScanned;
  static final List<String> scannedBarcodes = [];

  static void initializeScannerListener(Function(String) onScanned) {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "scannerKeyPressed") {
        String scannedData = call.arguments.toString();
        onScanned(scannedData);
      }
    });
  }

  static Future<bool> toggleTorch(
    MobileScannerController controller,
    bool currentState,
  ) async {
    await controller.toggleTorch();
    return !currentState;
  }

  /// Chuyển camera.
  static Future<void> switchCamera(MobileScannerController controller) async {
    await controller.switchCamera();
  }

  /// Reset scanner: dừng rồi khởi động lại.
  static Future<void> resetScanner(MobileScannerController controller) async {
    await controller.stop();
    await controller.start();
  }

  /// Xử lý kết quả quét: nếu có barcode, trả về giá trị đầu tiên; nếu không, trả về chuỗi rỗng.
  static String processBarcode(BarcodeCapture barcodeCapture) {
    if (barcodeCapture.barcodes.isNotEmpty) {
      final barcode = barcodeCapture.barcodes.first;
      return barcode.rawValue ?? "";
    }
    return "";
  }

  static bool isScannerButtonPressed(KeyEvent event) {
    return event.logicalKey.keyId == KeycodeConstants.scannerKeyCode;
  }

  static Future<void> triggerScan(
    MobileScannerController controller,
    Function(String) onScanned,
  ) async {
    await controller.start();
  }
}
