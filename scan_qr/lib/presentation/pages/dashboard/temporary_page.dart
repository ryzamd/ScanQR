import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/core/constants/style_contants.dart';
import 'package:scan_qr/core/utils/styles/scanner_styles.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_bloc.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_event.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_state.dart';
import 'package:scan_qr/presentation/mixins/scanner_page_mixin.dart';
import 'package:scan_qr/presentation/widgets/dialogs/custom_dialogs.dart';
import 'package:scan_qr/presentation/widgets/scanner_screens/scanner_screen.dart';

class TemporaryPage extends StatefulWidget {
  const TemporaryPage({super.key});

  @override
  State<TemporaryPage> createState() => _TemporaryPageState();
}

class _TemporaryPageState extends State<TemporaryPage> 
    with WidgetsBindingObserver, ScannerPageMixin<TemporaryPage> {
  final MobileScannerController _controller = MobileScannerController();
  final FocusNode _focusNode = FocusNode();
  static const EventChannel _eventChannel = EventChannel("com.example.scan_qr/scanner");
  String? _scanError;

  void _onScanReceived(dynamic scanData) {
    debugPrint("🔍 Dữ liệu quét nhận được: $scanData");
    
    if (scanData == null || scanData.toString().isEmpty || scanData == "No Scan Data Found") {
      debugPrint("⚠️ Dữ liệu quét không hợp lệ, bỏ qua");
      return;
    }

    // Phản hồi rung khi nhận được dữ liệu
    HapticFeedback.mediumImpact();

    // Gửi sự kiện đến BLoC
    final scanBloc = context.read<ScanBloc>();
    final String scanText = scanData.toString();
    
    if (scanBloc.state is ScanActive) {
      final currentState = scanBloc.state as ScanActive;
      
      // Kiểm tra xem mã này đã tồn tại chưa
      if (!currentState.scannedData.any((item) => item.isNotEmpty && item[0] == scanText)) {
        // Thêm dữ liệu vào BLoC
        scanBloc.add(ExternalScanDetected(scanText));
        debugPrint("✅ Đã thêm mã quét mới: $scanText");
        
        // Hiển thị thông báo
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
      } else {
        debugPrint("⚠️ Mã đã tồn tại: $scanText");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mã đã tồn tại: $scanText'),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      debugPrint("⚠️ Trạng thái BLoC không phải ScanActive: ${scanBloc.state}");
    }
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

  void _toggleCamera() {
    context.read<ScanBloc>().add(ToggleCameraRequested());
  }

  void _clearScannedData() {
    context.read<ScanBloc>().add(ClearScannedDataRequested());
  }

  Future<void> _saveScannedData() async {
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
  void initState() {
    super.initState(); // Gọi ScannerPageMixin.initState() được gọi ở đây
    WidgetsBinding.instance.addObserver(this);
    _focusNode.requestFocus();

    debugPrint("🔌 Đang thiết lập lắng nghe EventChannel");
    _eventChannel.receiveBroadcastStream().listen(
      _onScanReceived,
      onError: _onScanError,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Chỉ khởi động với camera tắt, KHÔNG gọi ToggleCameraRequested
        context.read<ScanBloc>().add(ScanStarted());
        debugPrint("▶️ Đã khởi động ScanBloc với camera mặc định tắt");
      }
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
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocConsumer<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is ScanSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dữ liệu đã được lưu thành công vào: ${state.filePath}'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ScanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        bool cameraActive = false;
        List<List<String>> scannedData = [];
        bool isSaving = false;
        
        if (state is ScanActive) {
          cameraActive = state.cameraActive;
          scannedData = state.scannedData;
        } else if (state is ScanSaving) {
          cameraActive = state.cameraActive;
          scannedData = state.scannedData;
          isSaving = true;
        } else if (state is ScanError) {
          cameraActive = state.cameraActive;
          scannedData = state.scannedData;
        }

        return KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (KeyEvent event) async {
            debugPrint("⌨️ Sự kiện bàn phím: ${event.runtimeType}");
          },
          child: SharedScannerScreen(
            title: const Text(
              "TEMPORARY",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            showAppBar: true,
            appBarColor: ColorsConstants.primaryColor,
            appBarElevation: 2.0,
            appBarActions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: IconButton(
                  icon: isSaving
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : const Icon(Icons.save, color: Colors.white),
                  onPressed: isSaving ? null : _saveScannedData,
                  tooltip: "Lưu dữ liệu đã quét",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: IconButton(
                  icon: Icon(
                    cameraActive ? Icons.camera_alt : Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  onPressed: _toggleCamera,
                  tooltip: cameraActive ? "Tắt camera" : "Bật camera",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () async {
                    final result = await CustomDialog.warning(
                      context: context,
                      title: "Cảnh báo",
                      message: "Bạn có chắc chắn muốn xóa tất cả dữ liệu đã quét?",
                      confirmLabel: null,
                      cancelLabel: null,
                      onConfirm: () {
                        _clearScannedData();
                      },
                    );

                    if (result == true) {
                      _clearScannedData();
                    }
                  },
                  tooltip: "Xóa toàn bộ dữ liệu đã quét",
                ),
              ),
            ],
            scannerController: _controller,
            cameraActive: cameraActive,
            onDetect: _onDetect,
            scannedData: scannedData,
            onScanAgain: _toggleCamera,
            onCameraOpen: _toggleCamera,
            tableHeaderLabels: const ["Code", "Status", "Quantity", "Total"],
            scannerSectionHeight: 160,
            scannerSectionWidth: 320,
            scannerBorderRadius: 12,
            scannerBorderColor: theme.primaryColor,
            scannerBackgroundColor: Colors.black87,
            tableHeaderColor: ShareScannerBusinessStyles.adjustOpacity(
              ColorsConstants.primaryColor,
              0.1,
            ),
            tableBorderColor: theme.dividerColor,
            scannerPadding: const EdgeInsets.all(8),
            errorMessage: _scanError,
            scanAgainButtonStyle: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            showBottomNavBar: true,
          ),
        );
      },
    );
  }
}