import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr/templates/navbars/navbar_widget.dart';
import 'package:scan_qr/utilites/contants/style_contants.dart';

/// Widget chung cho màn hình quét barcode, có thể tái sử dụng cho nhiều màn hình.
class SharedScannerScreen extends StatefulWidget {
  final Widget title;
  final bool showAppBar;
  final Color? appBarColor;
  final double? appBarElevation;
  final List<Widget>? appBarActions;
  final MobileScannerController scannerController;
  final bool cameraActive;
  final Function(BarcodeCapture)? onDetect;
  final List<List<String>> scannedData;
  final VoidCallback onScanAgain;
  final List<String>? tableHeaderLabels;
  final TextStyle? headerTextStyle;
  final TextStyle? rowTextStyle;
  final Color? tableHeaderColor;
  final Color? tableBorderColor;
  final EdgeInsetsGeometry? tableHeaderPadding;
  final EdgeInsetsGeometry? tableRowPadding;
  final double? tableRowSpacing;
  final double? scannerSectionHeight;
  final double? scannerSectionWidth;
  final double? scannerBorderRadius;
  final Color? scannerBorderColor;
  final EdgeInsetsGeometry? scannerPadding;
  final VoidCallback? onCameraOpen;
  final Color? scannerBackgroundColor;
  final TextStyle? noDataTextStyle;
  final ButtonStyle? scanAgainButtonStyle;
  final String? errorMessage;
  final bool showBottomNavBar;

  const SharedScannerScreen({
    super.key,
    required this.title,
    this.showAppBar = true,
    this.appBarColor,
    this.appBarElevation,
    this.appBarActions,
    required this.scannerController,
    required this.cameraActive,
    this.onDetect,
    required this.scannedData,
    required this.onScanAgain,
    this.tableHeaderLabels,
    this.headerTextStyle,
    this.rowTextStyle,
    this.tableHeaderColor,
    this.tableBorderColor,
    this.tableHeaderPadding,
    this.tableRowPadding,
    this.tableRowSpacing,
    this.scannerSectionHeight,
    this.scannerSectionWidth,
    this.scannerBorderRadius,
    this.scannerBorderColor,
    this.scannerPadding,
    this.onCameraOpen,
    this.scannerBackgroundColor,
    this.noDataTextStyle,
    this.scanAgainButtonStyle,
    this.errorMessage,
    required this.showBottomNavBar,
  });

  @override
  SharedScannerScreenState createState() => SharedScannerScreenState();
}

class SharedScannerScreenState extends State<SharedScannerScreen>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = Theme.of(context);
    final headers =
        widget.tableHeaderLabels ?? ["Code", "Status", "Quantity", "Total"];

    return Scaffold(
      backgroundColor: Colors.grey[100], // Thêm màu nền xám nhạt
      appBar:
          widget.showAppBar
              ? AppBar(
                titleSpacing: -8,
                title: widget.title,
                backgroundColor: ColorsConstants.primaryColor,
                elevation: widget.appBarElevation,
                actions: widget.appBarActions ?? [],
              )
              : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Camera section (thu nhỏ lại)
            Container(
              padding: widget.scannerPadding ?? const EdgeInsets.all(8),
              height:
                  widget.scannerSectionHeight ??
                  120, // Giảm kích thước chiều cao
              decoration: BoxDecoration(
                color: widget.scannerBackgroundColor ?? Colors.black,
                borderRadius: BorderRadius.circular(
                  widget.scannerBorderRadius ?? 8,
                ),
                border:
                    widget.scannerBorderColor != null
                        ? Border.all(color: widget.scannerBorderColor!)
                        : null,
              ),
              child: Center(
                child:
                    widget.cameraActive
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            (widget.scannerBorderRadius ?? 8) - 4,
                          ),
                          child: MobileScanner(
                            controller: widget.scannerController,
                            onDetect: widget.onDetect,
                          ),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 36, // Icon nhỏ hơn
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Camera is off",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
              ),
            ),

            if (widget.errorMessage != null) _buildErrorMessage(),

            // Scan Results header
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Scan Results (${widget.scannedData.length})",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.scannedData.isNotEmpty)
                    SizedBox(child: Text("${widget.scannedData.length} items")),
                ],
              ),
            ),

            // Mở rộng bảng kết quả
            Expanded(
              flex: 3, // Tăng tỉ lệ flex để bảng kết quả lớn hơn
              child: _buildTable(headers, widget.scannedData),
            ),

            const SizedBox(height: 8),

            // Scan Again button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton.icon(
                style:
                    widget.scanAgainButtonStyle ??
                    ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                onPressed: widget.onScanAgain,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("Scan Again"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          widget.showBottomNavBar ? const NavbarWidget() : null,
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 244, 67, 54).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<String> headers, List<List<String>> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: widget.tableBorderColor ?? Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildTableHeader(headers),
          Expanded(
            child:
                data.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                      itemCount: data.length,
                      separatorBuilder:
                          (context, index) => Divider(
                            height: 1,
                            color:
                                widget.tableBorderColor ?? Colors.grey.shade200,
                          ),
                      itemBuilder:
                          (context, index) => _buildTableRow(data[index]),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No items scanned yet",
            style:
                widget.noDataTextStyle ??
                TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    // Tỉ lệ chiều rộng cột: 4-3-2-2
    const List<int> columnRatios = [3, 3, 3, 3];

    return Container(
      padding:
          widget.tableHeaderPadding ??
          const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: widget.tableHeaderColor ?? Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children:
            headers.asMap().entries.map((entry) {
              final int idx = entry.key;
              final String header = entry.value;

              // Lấy tỉ lệ đúng theo chỉ số cột
              final int ratio =
                  idx < columnRatios.length ? columnRatios[idx] : 1;

              return Expanded(
                flex: ratio,
                child: Text(
                  header,
                  textAlign: TextAlign.center,
                  style:
                      widget.headerTextStyle ??
                      const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTableRow(List<String> values) {
    // Tỉ lệ chiều rộng cột: 4-3-2-2 (giữ nhất quán với header)
    const List<int> columnRatios = [3, 3, 3, 3];

    return Padding(
      padding:
          widget.tableRowPadding ??
          const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children:
            values.asMap().entries.map((entry) {
              final int idx = entry.key;
              final String value = entry.value;

              // Lấy tỉ lệ đúng theo chỉ số cột
              final int ratio =
                  idx < columnRatios.length ? columnRatios[idx] : 1;

              return Expanded(
                flex: ratio,
                child: Text(
                  textAlign: TextAlign.center,
                  value,
                  style: widget.rowTextStyle ?? const TextStyle(),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
      ),
    );
  }
}
