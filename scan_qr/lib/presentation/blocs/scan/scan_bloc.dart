import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
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
    on<ExternalScanDetected>(_onExternalScanDetected);
  }

  void _onScanStarted(ScanStarted event, Emitter<ScanState> emit) {
    debugPrint("🚀 ScanBloc: Bắt đầu quét, camera mặc định TẮT");
    // Stop camera ngay từ đầu khi emit state
    scannerController.stop();
    emit(ScanActive(scannedData: [], cameraActive: false));
  }

  void _onBarcodeDetected(BarcodeDetected event, Emitter<ScanState> emit) {
    debugPrint("📷 ScanBloc: Phát hiện mã qua camera");
    if (state is ScanActive) {
      final currentState = state as ScanActive;
      final List<List<String>> updatedData = List.from(currentState.scannedData);
      
      for (final barcode in event.capture.barcodes) {
        final String? rawValue = barcode.rawValue;
        if (rawValue != null && !updatedData.any((item) => item.isNotEmpty && item[0] == rawValue)) {
          updatedData.add([rawValue, "Detected", "1", "0.00"]);
          debugPrint("✅ ScanBloc: Đã thêm mã mới từ camera: $rawValue");
        }
      }
      
      emit(currentState.copyWith(scannedData: updatedData));
    }
  }

  void _onExternalScanDetected(ExternalScanDetected event, Emitter<ScanState> emit) {
    debugPrint("📱 ScanBloc: Phát hiện mã từ thiết bị vật lý: ${event.scanData}");
    if (state is ScanActive) {
      final currentState = state as ScanActive;
      final List<List<String>> updatedData = List.from(currentState.scannedData);
      
      // Kiểm tra không trùng lặp
      if (!updatedData.any((item) => item.isNotEmpty && item[0] == event.scanData)) {
        updatedData.add([event.scanData, "External", "1", "0.00"]);
        debugPrint("✅ ScanBloc: Đã thêm mã từ thiết bị vật lý: ${event.scanData}");
        emit(currentState.copyWith(scannedData: updatedData));
      } else {
        debugPrint("⚠️ ScanBloc: Mã đã tồn tại: ${event.scanData}");
      }
    } else {
      // Nếu chưa có trạng thái Active, tạo state mới
      debugPrint("🔄 ScanBloc: Chuyển sang trạng thái ScanActive và thêm dữ liệu mới");
      final List<List<String>> newData = [[event.scanData, "External", "1", "0.00"]];
      emit(ScanActive(scannedData: newData, cameraActive: false));
    }
  }

  void _onScanStopped(ScanStopped event, Emitter<ScanState> emit) {
    debugPrint("🛑 ScanBloc: Dừng quét");
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
    debugPrint("💾 ScanBloc: Yêu cầu lưu dữ liệu");
    if (state is ScanActive) {
      final currentState = state as ScanActive;
      
      if (event.scannedData.isEmpty) {
        debugPrint("⚠️ ScanBloc: Không có dữ liệu để lưu");
        emit(ScanError(
          message: 'Không có dữ liệu để lưu',
          scannedData: currentState.scannedData,
          cameraActive: currentState.cameraActive
        ));
        return;
      }
      
      debugPrint("⏳ ScanBloc: Đang lưu dữ liệu...");
      emit(ScanSaving(
        scannedData: currentState.scannedData,
        cameraActive: currentState.cameraActive
      ));
      
      try {
        final filePath = await saveScanDataUseCase.execute(event.scannedData);
        
        if (filePath.isNotEmpty) {
          debugPrint("✅ ScanBloc: Đã lưu dữ liệu thành công vào: $filePath");
          emit(ScanSaveSuccess(
            filePath: filePath,
            cameraActive: currentState.cameraActive
          ));
          
          // Làm sạch danh sách sau khi lưu thành công
          emit(ScanActive(scannedData: [], cameraActive: currentState.cameraActive));
        } else {
          debugPrint("❌ ScanBloc: Không thể lưu dữ liệu");
          emit(ScanError(
            message: 'Không thể lưu dữ liệu',
            scannedData: currentState.scannedData,
            cameraActive: currentState.cameraActive
          ));
        }
      } catch (e) {
        debugPrint("❌ ScanBloc: Lỗi khi lưu dữ liệu: $e");
        emit(ScanError(
          message: 'Lỗi khi lưu dữ liệu: $e',
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
    debugPrint("🧹 ScanBloc: Xóa tất cả dữ liệu đã quét");
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
        debugPrint("📷 ScanBloc: Bật camera");
        scannerController.start();
      } else {
        debugPrint("📷 ScanBloc: Tắt camera");
        scannerController.stop();
      }
      
      emit(currentState.copyWith(cameraActive: newCameraActive));
    } else if (state is ScanInitial) {
      // Nếu vẫn trong trạng thái ban đầu
      debugPrint("📷 ScanBloc: Khởi tạo với camera tắt");
      scannerController.stop();
      emit(ScanActive(scannedData: [], cameraActive: false));
    }
  }

  @override
  Future<void> close() {
    scannerController.dispose();
    return super.close();
  }
}