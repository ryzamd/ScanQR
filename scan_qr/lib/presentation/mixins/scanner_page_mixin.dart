import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin ScannerPageMixin<T extends StatefulWidget> on State<T> {
  static const MethodChannel _methodChannel = MethodChannel('com.example.scan_qr/scanner_method');
  
  @override
  void initState() {
    super.initState();
    _notifyEnterScanPage();
  }

  @override
  void dispose() {
    _notifyExitScanPage();
    super.dispose();
  }
  
  Future<void> _notifyEnterScanPage() async {
    try {
      await _methodChannel.invokeMethod('enterScanPage');
      debugPrint("✅ Đã thông báo native: Vào trang scanner");
    } catch (e) {
      debugPrint("❌ Lỗi khi thông báo native: $e");
    }
  }
  
  Future<void> _notifyExitScanPage() async {
    try {
      await _methodChannel.invokeMethod('exitScanPage');
      debugPrint("✅ Đã thông báo native: Thoát trang scanner");
    } catch (e) {
      debugPrint("❌ Lỗi khi thông báo native: $e");
    }
  }
}