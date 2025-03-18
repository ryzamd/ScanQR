import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/core/constants/style_contants.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_bloc.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_event.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_state.dart';
import 'package:scan_qr/presentation/mixins/scanner_page_mixin.dart';
import 'package:scan_qr/presentation/widgets/scanner_screens/scanner_screen.dart';


class OutboundCategoryScanPage extends StatefulWidget {
  final VoidCallback? onCameraToggle;
  final VoidCallback? onClearData;
  final String? selectedType;

  const OutboundCategoryScanPage({
    super.key,
    this.onCameraToggle,
    this.onClearData,
    this.selectedType,
  });

  @override
  State<OutboundCategoryScanPage> createState() => OutboundCategoryScanPageState();
}

class OutboundCategoryScanPageState extends State<OutboundCategoryScanPage> 
    with WidgetsBindingObserver, ScannerPageMixin<OutboundCategoryScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  final FocusNode _focusNode = FocusNode();
  static const EventChannel _eventChannel = EventChannel("com.example.scan_qr/scanner");

  String? _scanError;

  void _onScanReceived(dynamic scanData) {
    debugPrint("📡 Dữ liệu quét nhận được: $scanData");
    
    if (scanData == null || scanData.toString().isEmpty || scanData == "No Scan Data Found") {
      debugPrint("⚠️ Dữ liệu quét không hợp lệ, bỏ qua");
      return;
    }

    // Phản hồi rung khi nhận được dữ liệu
    HapticFeedback.mediumImpact();

    // Gửi sự kiện đến BLoC
    final scanBloc = context.read<ScanBloc>();
    final String scanText = scanData.toString();
    
    // Sử dụng ExternalScanDetected event thay vì SaveScannedDataRequested
    scanBloc.add(ExternalScanDetected(scanText));
    
    // Hiển thị thông báo tạm thời
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã quét được mã: $scanText'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
    
    setState(() {
      _scanError = null;
    });
  }

  void _onScanError(Object error) {
    debugPrint("❌ Lỗi nhận dữ liệu quét: $error");
    setState(() {
      _scanError = "Lỗi xử lý dữ liệu quét: $error";
    });
  }

  void _onDetect(BarcodeCapture capture) {
    context.read<ScanBloc>().add(BarcodeDetected(capture));
  }

  @override
  void initState() {
    super.initState(); // Gọi ScannerPageMixin.initState() được gọi ở đây
    WidgetsBinding.instance.addObserver(this);
    _focusNode.requestFocus();

    debugPrint("🔌 Đang thiết lập lắng nghe EventChannel");
    _eventChannel.receiveBroadcastStream().listen(
      _onScanReceived,
      onError: _onScanError,
    );
    
    // Chỉ khởi động với ScanStarted, KHÔNG gọi ToggleCameraRequested
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanBloc>().add(ScanStarted());
      debugPrint("▶️ Đã khởi động ScanBloc với camera mặc định tắt");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose(); // ScannerPageMixin.dispose() được gọi ở đây
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final scanBloc = context.read<ScanBloc>();
    if (scanBloc.state is! ScanActive) return;
    
    final isActive = (scanBloc.state as ScanActive).cameraActive;
    if (!isActive) return;
    
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _controller.pause();
      debugPrint("⏸️ Camera tạm dừng do ứng dụng không hiển thị");
    } else if (state == AppLifecycleState.resumed) {
      _controller.start();
      debugPrint("▶️ Camera khởi động lại do ứng dụng hiển thị");
    }
  }

  Future<void> _resetScanner() async {
    debugPrint("🔄 Đang khởi động lại scanner");
    await _controller.stop();
    await _controller.start();
    context.read<ScanBloc>().add(ScanStarted());
  }

  void toggleCamera() {
    debugPrint("🔄 Chuyển đổi trạng thái camera");
    context.read<ScanBloc>().add(ToggleCameraRequested());
    
    if (widget.onCameraToggle != null) {
      widget.onCameraToggle!();
    }
  }

  void clearScannedData() {
    debugPrint("🧹 Xóa dữ liệu đã quét");
    context.read<ScanBloc>().add(ClearScannedDataRequested());
    
    if (widget.onClearData != null) {
      widget.onClearData!();
    }
  }

  void saveScannedData() {
    debugPrint("💾 Lưu dữ liệu đã quét");
    final scanBloc = context.read<ScanBloc>();
    if (scanBloc.state is ScanActive) {
      final scannedData = (scanBloc.state as ScanActive).scannedData;
      if (scannedData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không có dữ liệu để lưu'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      scanBloc.add(SaveScannedDataRequested(scannedData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanBloc, ScanState>(
      builder: (context, state) {
        bool cameraActive = false;
        List<List<String>> scannedData = [];
        
        if (state is ScanActive) {
          cameraActive = state.cameraActive;
          scannedData = state.scannedData;
        } else if (state is ScanSaving) {
          cameraActive = state.cameraActive;
          scannedData = state.scannedData;
        } else if (state is ScanError) {
          cameraActive = state.cameraActive;
          scannedData = state.scannedData;
        }

        return SharedScannerScreen(
          title: Text(""),
          showAppBar: false,
          scannerController: _controller,
          cameraActive: cameraActive,
          onDetect: _onDetect,
          scannedData: scannedData,
          onScanAgain: _resetScanner,
          tableHeaderLabels: const ["Code", "Status", "Quantity", "Total"],
          scannerSectionHeight: 160,
          scannerSectionWidth: 320,
          scannerBorderRadius: 12,
          scannerBorderColor: Colors.black87,
          scannerBackgroundColor: Colors.black87,
          tableHeaderColor: Colors.blue.shade50,
          tableBorderColor: Colors.grey.shade300,
          headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: ColorsConstants.primaryColor,
          ),
          rowTextStyle: const TextStyle(fontSize: 13),
          tableHeaderPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          tableRowPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          noDataTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          scanAgainButtonStyle: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: ColorsConstants.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onCameraOpen: toggleCamera,
          showBottomNavBar: false,
          errorMessage: _scanError,
        );
      },
    );
  }
}