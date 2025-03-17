// file: lib/presentation/pages/dashboard/temporary_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/core/constants/style_contants.dart';
import 'package:scan_qr/core/utils/styles/scanner_styles.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_bloc.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_event.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_state.dart';
import 'package:scan_qr/presentation/widgets/dialogs/custom_dialogs.dart';
import 'package:scan_qr/presentation/widgets/scanner_screens/scanner_screen.dart';


class TemporaryPage extends StatefulWidget {
  const TemporaryPage({super.key});

  @override
  State<TemporaryPage> createState() => _TemporaryPageState();
}

class _TemporaryPageState extends State<TemporaryPage> with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController();
  final FocusNode _focusNode = FocusNode();
  static const EventChannel _eventChannel = EventChannel("com.example.scan_qr/scanner");
  String? _scanError;

  void _onScanReceived(dynamic scanData) {
    debugPrint("📡 Real-time Scan Data: $scanData");

    if (scanData == "❌ No Scan Data Found") {
      debugPrint("⚠️ Ignoring invalid scan data.");
      return;
    }

    final scanBloc = context.read<ScanBloc>();
    if (scanBloc.state is ScanActive) {
      final currentState = scanBloc.state as ScanActive;
      if (!currentState.scannedData.any((row) => row.contains(scanData))) {
        final updatedData = List<List<String>>.from(currentState.scannedData);
        updatedData.add([scanData, "Pending", "1", "0.00"]);
        
        final ScanBloc scanBloc = context.read<ScanBloc>();
        scanBloc.add(SaveScannedDataRequested(updatedData));
        setState(() {
          _scanError = null;
        });
      }
    }
  }

  void _onScanError(Object error) {
    debugPrint("❌ Error receiving scan data: $error");
    setState(() {
      _scanError = "Failed to process scan: $error";
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
            content: Text('No data to save'),
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
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  _focusNode.requestFocus();

  _eventChannel.receiveBroadcastStream().listen(
    _onScanReceived,
    onError: _onScanError,
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      context.read<ScanBloc>().add(ScanStarted());
    }
  });
}


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocConsumer<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is ScanSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data saved successfully to: ${state.filePath}'),
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
            debugPrint("🔍 Event Captured: ${event.runtimeType}");
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
                    : const Icon(Icons.save, color: Colors.black),
                  onPressed: isSaving ? null : _saveScannedData,
                  tooltip: "Save scanned data",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: IconButton(
                  icon: Icon(
                    cameraActive ? Icons.camera_alt : Icons.camera_alt,
                    color: Colors.black,
                  ),
                  onPressed: _toggleCamera,
                  tooltip: cameraActive ? "Turn off camera" : "Turn on camera",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.black),
                  onPressed: () async {
                    final result = await CustomDialog.warning(
                      context: context,
                      title: "Warning",
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
                  tooltip: "Clear all scanned items",
                ),
              ),
            ],
            bottomActions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ElevatedButton.icon(
                  icon: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.save),
                  label: Text(isSaving ? "Saving..." : "Save Data"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: isSaving ? null : _saveScannedData,
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