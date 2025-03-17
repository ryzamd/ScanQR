import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/services/scan_save_data_service.dart';
import 'package:scan_qr/templates/scanner_screens/scanner_screen.dart';
import 'package:scan_qr/utilites/contants/style_contants.dart';

class OutboundCategoryScanScreen extends StatefulWidget {
  final VoidCallback? onCameraToggle;
  final VoidCallback? onClearData;

  const OutboundCategoryScanScreen({
    super.key,
    this.onCameraToggle,
    this.onClearData,
  });

  @override
  State<OutboundCategoryScanScreen> createState() =>
      OutboundCategoryScanScreenState();
}

class OutboundCategoryScanScreenState extends State<OutboundCategoryScanScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController();
  final FocusNode _focusNode = FocusNode();
  static const EventChannel _eventChannel = EventChannel(
    "com.example.scan_qr/scanner",
  );

  List<List<String>> scannedData = [];

  bool _cameraActive = false;
  bool _isSaving = false;

  String? _scanError = "Error message";

  void _onScanReceived(dynamic scanData) {
    debugPrint("📡 Real-time Scan Data: $scanData");

    if (scanData == "No Scan Data Found") {
      debugPrint("Ignoring invalid scan data.");
      return;
    }

    if (!scannedData.any((row) => row.contains(scanData))) {
      setState(() {
        scannedData.add([scanData, "Pending", "1", "0.00"]);
        _scanError = null;
      });
    }
  }

  void _onScanError(Object error) {
    debugPrint("Error receiving scan data: $error");
    setState(() {
      _scanError = "Failed to process scan: $error";
    });
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null &&
          !scannedData.any((row) => row.contains(rawValue))) {
        setState(() {
          scannedData.add([rawValue, "Detected", "1", "0.00"]);
          _scanError = null;
        });
      }
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
    if (!_cameraActive) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controller.start();
    }
  }

  Future<void> _resetScanner() async {
    await _controller.stop();
    await _controller.start();
    setState(() {
      _cameraActive = true;
    });
  }

  void toggleCamera() {
    setState(() {
      _cameraActive = !_cameraActive;
      if (_cameraActive) {
        _controller.start();
      } else {
        _controller.stop();
      }
    });

    if (widget.onCameraToggle != null) {
      widget.onCameraToggle!();
    }
  }

  void clearScannedData() {
    setState(() {
      scannedData.clear();
    });

    if (widget.onClearData != null) {
      widget.onClearData!();
    }
  }

     Future<void> saveScannedData() async {
    if (scannedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No data to save'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final String filePath = await ScanDataSaverService.saveScannedData(scannedData);
      
      if (filePath.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data saved successfully to: $filePath'),
            backgroundColor: Colors.green,
          ),
        );

        clearScannedData();
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error in _saveScannedData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedScannerScreen(
      title: const Text(""),
      showAppBar: false,
      scannerController: _controller,
      cameraActive: _cameraActive,
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
    );
  }
}
