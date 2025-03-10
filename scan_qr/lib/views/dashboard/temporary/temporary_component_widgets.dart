import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TemporaryComponentWidgets {
  static Widget _buildTableHeader(BuildContext context) {
    return Container(
      color: Colors.grey[350],
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const
        [
              Expanded(child: Text("Code Name", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              Expanded(child: Text("Status", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              Expanded(child: Text("Quantity", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              Expanded(child: Text("Total", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
        ],
      ),
    );
  }

  static Widget _buildTableRow(BuildContext context, int index, List<String> scannedValues,)
  {
    String category = index < scannedValues.length ? scannedValues[index] : "N/A";
    String status = "Pending";
    String quantity = "--";
    String total = "--";
    
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(category,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),),
          Expanded(
            child: Text(status,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),),
          Expanded(
            child: Text(quantity,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),),
          Expanded(
            child: Text(total,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),),
        ],
      ),
    );
  }


  static Widget _buildTableData(BuildContext context, List<String> scannedValues) {
    return SizedBox(
      height: 280,
      width: double.maxFinite,
      child: scannedValues.isEmpty
                ? const Center(child: Text("No scanned data"))
                : ListView.builder(
        itemCount: scannedValues.length,
        itemBuilder: (context, index) {
          return _buildTableRow(context, index, scannedValues);
        },
      ),
    );
  }

  static Widget buildFeatureTableTemporary(
    BuildContext context,
    List<String> scannedValues,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.black),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Column(
        children: [
          _buildTableHeader(context),
          _buildTableData(context, scannedValues),
        ],
      ),
    );
  }

  static buildTemporaryAppBar({
    required bool torchEnabled,
    required bool cameraActive,
    required VoidCallback onToggleCamera,
    required Future<void> Function() onToggleTorch,
    required Future<void> Function() onSwitchCamera,
  }) {
    return AppBar(
      backgroundColor: Colors.blue,
      toolbarHeight: 50,
      title: const Center(child: Text("TEMPORARY", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
      actions: [
        IconButton(
          iconSize: 24,
          icon: Icon(
            torchEnabled ? Icons.flash_on : Icons.flash_off,
            color: Colors.yellow,
          ),
          onPressed:
              cameraActive
                  ? () async {
                    await onToggleTorch();
                  }
                  : null,
        ),
        IconButton(
          iconSize: 24,
          icon: const Icon(Icons.flip_camera_ios),
          onPressed:
              cameraActive
                  ? () async {
                    await onSwitchCamera();
                  }
                  : null,
        ),
        IconButton(
          iconSize: 24,
          icon: Icon(
            cameraActive ? Icons.stop : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: onToggleCamera,
        ),
      ],
    );
  }

  static Widget buildTemporaryScannerSection({
    required bool cameraActive,
    required MobileScannerController controller,
    required Function(BarcodeCapture) onDetect,
  }) {
    return SizedBox(
      height: 150,
      width: 300,
      child: cameraActive
          ? MobileScanner(
              controller: controller,
              onDetect: onDetect,
            )
          : Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Camera is off",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
    );
  }

  /// Nút "Scan Again".
  static Widget buildTemporaryScanAgainButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text("Scan Again"),
    );
  }
}
