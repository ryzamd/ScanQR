import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/core/constants/style_contants.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_bloc.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_event.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_state.dart';
import 'package:scan_qr/presentation/widgets/scanner_screens/scanner_screen.dart';


class OutboundCategoryScanPage extends StatefulWidget {
  final VoidCallback? onCameraToggle;
  final VoidCallback? onClearData;

  const OutboundCategoryScanPage({
    super.key,
    this.onCameraToggle,
    this.onClearData,
  });

  @override
  State<OutboundCategoryScanPage> createState() => OutboundCategoryScanPageState();
}

class OutboundCategoryScanPageState extends State<OutboundCategoryScanPage> with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController();
  final FocusNode _focusNode = FocusNode();
  static const EventChannel _eventChannel = EventChannel("com.example.scan_qr/scanner");

  String? _scanError;

  void _onScanReceived(dynamic scanData) {
    debugPrint("📡 Real-time Scan Data: $scanData");

    if (scanData == "No Scan Data Found") {
      debugPrint("Ignoring invalid scan data.");
      return;
    }

    final scanBloc = context.read<ScanBloc>();
    if (scanBloc.state is ScanActive) {
      final currentState = scanBloc.state as ScanActive;
      if (!currentState.scannedData.any((row) => row.contains(scanData))) {
        final updatedData = List<List<String>>.from(currentState.scannedData);
        updatedData.add([scanData, "Pending", "1", "0.00"]);
        
        scanBloc.add(SaveScannedDataRequested(updatedData));
        setState(() {
          _scanError = null;
        });
      }
    }
  }

  void _onScanError(Object error) {
    debugPrint("Error receiving scan data: $error");
    setState(() {
      _scanError = "Failed to process scan: $error";
    });
  }

  void _onDetect(BarcodeCapture capture) {
    context.read<ScanBloc>().add(BarcodeDetected(capture));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.requestFocus();

    _eventChannel.receiveBroadcastStream().listen(
      _onScanReceived,
      onError: _onScanError,
    );
    
    context.read<ScanBloc>().add(ScanStarted());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final scanBloc = context.read<ScanBloc>();
    if (scanBloc.state is! ScanActive) return;
    
    final isActive = (scanBloc.state as ScanActive).cameraActive;
    if (!isActive) return;
    
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controller.start();
    }
  }

  Future<void> _resetScanner() async {
    await _controller.stop();
    await _controller.start();
    context.read<ScanBloc>().add(ScanStarted());
  }

  void toggleCamera() {
    context.read<ScanBloc>().add(ToggleCameraRequested());
    
    if (widget.onCameraToggle != null) {
      widget.onCameraToggle!();
    }
  }

  void clearScannedData() {
    context.read<ScanBloc>().add(ClearScannedDataRequested());
    
    if (widget.onClearData != null) {
      widget.onClearData!();
    }
  }

  void saveScannedData() {
    final scanBloc = context.read<ScanBloc>();
    if (scanBloc.state is ScanActive) {
      final scannedData = (scanBloc.state as ScanActive).scannedData;
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
          title: const Text(""),
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