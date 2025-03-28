import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/services/scan_save_data_service.dart';
import 'package:scan_qr/templates/dialogs/custom_dialogs.dart';
import 'package:scan_qr/templates/scanner_screens/scanner_screen.dart';
import 'package:scan_qr/templates/scanner_screens/scanner_styles.dart';
import 'package:scan_qr/utilites/contants/style_contants.dart';

class TemporaryScreen extends StatefulWidget {
  const TemporaryScreen({super.key});

  @override
  State<TemporaryScreen> createState() => _TemporaryScreenState();
}

class _TemporaryScreenState extends State<TemporaryScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController();
  final FocusNode _focusNode = FocusNode();
  static const EventChannel _eventChannel = EventChannel(
    "com.example.scan_qr/scanner",
  );
  List<List<String>> scannedBarcodes = [];
  bool _cameraActive = false;
  String? _scanError;
  bool _isSaving = false;

  void _onScanReceived(dynamic scanData) {
    debugPrint("📡 Real-time Scan Data: $scanData");

    if (scanData == "❌ No Scan Data Found") {
      debugPrint("⚠️ Ignoring invalid scan data.");
      return;
    }

    if (!scannedBarcodes.any((row) => row.contains(scanData))) {
      setState(() {
        scannedBarcodes.add([scanData, "Pending", "1", "0.00"]);
        _scanError = null;
      });
    }
  }

  void _onScanError(Object error) {
    debugPrint("❌ Error receiving scan data: $error");
    setState(() {
      _scanError = "Failed to process scan: $error";
    });
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null &&
          !scannedBarcodes.any((row) => row.contains(rawValue))) {
        setState(() {
          scannedBarcodes.add([rawValue, "Detected", "1", "0.00"]);
          _scanError = null;
        });
      }
    }
  }

  void _toggleCamera() {
    setState(() {
      _cameraActive = !_cameraActive;
      if (_cameraActive) {
        _controller.start();
      } else {
        _controller.stop();
      }
    });
  }

  void _clearScannedData() {
    setState(() {
      scannedBarcodes.clear();
    });
  }

    Future<void> _saveScannedData() async {
    if (scannedBarcodes.isEmpty) {
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
      final String filePath = await ScanDataSaverService.saveScannedData(scannedBarcodes);
      
      if (filePath.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data saved successfully to: $filePath'),
            backgroundColor: Colors.green,
          ),
        );

        _clearScannedData();
        
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
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
              icon: _isSaving 
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : const Icon(Icons.save, color: Colors.black),
              onPressed: _isSaving ? null : _saveScannedData,
              tooltip: "Save scanned data",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: IconButton(
              icon: Icon(
                _cameraActive ? Icons.camera_alt : Icons.camera_alt,
                color: Colors.black,
              ),
              onPressed: _toggleCamera,
              tooltip: _cameraActive ? "Turn off camera" : "Turn on camera",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black),
              onPressed: () async {
                // Thêm một anonymous async function
                final result = await CustomDialog.warning(
                  context: context,
                  title: "Warning",
                  message: "Bạn có chắc chắn muốn xóa tất cả dữ liệu đã quét?",
                  confirmLabel: null,
                  cancelLabel: null,
                  onConfirm: () {
                    _clearScannedData(); // Gọi hàm xóa dữ liệu
                  },
                );

                if (result == true) {
                  // Nếu người dùng đã xác nhận, thực hiện xóa
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
              icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.save),
              label: Text(_isSaving ? "Saving..." : "Save Data"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _isSaving ? null : _saveScannedData,
            ),
          ),
        ],
        scannerController: _controller,
        cameraActive: _cameraActive,
        onDetect: _onDetect,
        scannedData: scannedBarcodes,
        onScanAgain: _toggleCamera,
        onCameraOpen: _toggleCamera,
        tableHeaderLabels: const ["Code", "Status", "Quantity", "Total"],
        // Điều chỉnh kích thước để hiển thị nhỏ gọn hơn
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
        // Tùy chỉnh style nút "Scan Again"
        scanAgainButtonStyle: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        showBottomNavBar: true,
      ),
    );
  }
}
