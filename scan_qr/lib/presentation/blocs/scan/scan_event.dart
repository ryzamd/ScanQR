import 'package:mobile_scanner/mobile_scanner.dart';

abstract class ScanEvent {}

class ScanStarted extends ScanEvent {}

class BarcodeDetected extends ScanEvent {
  final BarcodeCapture capture;

  BarcodeDetected(this.capture);
}

class ScanStopped extends ScanEvent {}

class SaveScannedDataRequested extends ScanEvent {
  final List<List<String>> scannedData;

  SaveScannedDataRequested(this.scannedData);
}

class ClearScannedDataRequested extends ScanEvent {}

class ToggleCameraRequested extends ScanEvent {}