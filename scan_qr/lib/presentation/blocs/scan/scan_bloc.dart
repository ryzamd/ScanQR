// file: lib/presentation/blocs/scan/scan_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/domain/usescases/save_scan_data_usecase.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_event.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_state.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final SaveScanDataUseCase saveScanDataUseCase;
  final MobileScannerController scannerController = MobileScannerController();
  
  ScanBloc({required this.saveScanDataUseCase}) : super(ScanInitial()) {
    on<ScanStarted>(_onScanStarted);
    on<BarcodeDetected>(_onBarcodeDetected);
    on<ScanStopped>(_onScanStopped);
    on<SaveScannedDataRequested>(_onSaveScannedDataRequested);
    on<ClearScannedDataRequested>(_onClearScannedDataRequested);
    on<ToggleCameraRequested>(_onToggleCameraRequested);
  }

  void _onScanStarted(ScanStarted event, Emitter<ScanState> emit) {
    emit(ScanActive(scannedData: [], cameraActive: true));
    scannerController.start();
  }

  void _onBarcodeDetected(BarcodeDetected event, Emitter<ScanState> emit) {
    if (state is ScanActive) {
      final currentState = state as ScanActive;
      final List<List<String>> updatedData = List.from(currentState.scannedData);
      
      for (final barcode in event.capture.barcodes) {
        final String? rawValue = barcode.rawValue;
        if (rawValue != null && !updatedData.any((item) => item[0] == rawValue)) {
          updatedData.add([rawValue, "Detected", "1", "0.00"]);
        }
      }
      
      emit(currentState.copyWith(scannedData: updatedData));
    }
  }

  void _onScanStopped(ScanStopped event, Emitter<ScanState> emit) {
    if (state is ScanActive) {
      final currentState = state as ScanActive;
      scannerController.stop();
      emit(currentState.copyWith(cameraActive: false));
    }
  }

  Future<void> _onSaveScannedDataRequested(
    SaveScannedDataRequested event, 
    Emitter<ScanState> emit
  ) async {
    if (state is ScanActive) {
      final currentState = state as ScanActive;
      
      if (event.scannedData.isEmpty) {
        emit(ScanError(
          message: 'No data to save',
          scannedData: currentState.scannedData,
          cameraActive: currentState.cameraActive
        ));
        return;
      }
      
      emit(ScanSaving(
        scannedData: currentState.scannedData,
        cameraActive: currentState.cameraActive
      ));
      
      try {
        final filePath = await saveScanDataUseCase.execute(event.scannedData);
        
        if (filePath.isNotEmpty) {
          emit(ScanSaveSuccess(
            filePath: filePath,
            cameraActive: currentState.cameraActive
          ));
          
          // Reset after successful save
          emit(ScanActive(scannedData: [], cameraActive: currentState.cameraActive));
        } else {
          emit(ScanError(
            message: 'Failed to save data',
            scannedData: currentState.scannedData,
            cameraActive: currentState.cameraActive
          ));
        }
      } catch (e) {
        emit(ScanError(
          message: 'Error saving data: $e',
          scannedData: currentState.scannedData,
          cameraActive: currentState.cameraActive
        ));
      }
    }
  }

  void _onClearScannedDataRequested(
    ClearScannedDataRequested event, 
    Emitter<ScanState> emit
  ) {
    if (state is ScanActive) {
      final currentState = state as ScanActive;
      emit(currentState.copyWith(scannedData: []));
    }
  }

  void _onToggleCameraRequested(
    ToggleCameraRequested event, 
    Emitter<ScanState> emit
  ) {
    if (state is ScanActive) {
      final currentState = state as ScanActive;
      final newCameraActive = !currentState.cameraActive;
      
      if (newCameraActive) {
        scannerController.start();
      } else {
        scannerController.stop();
      }
      
      emit(currentState.copyWith(cameraActive: newCameraActive));
    }
  }

  @override
  Future<void> close() {
    scannerController.dispose();
    return super.close();
  }
}