import 'package:flutter/material.dart';
import 'package:scan_qr/routes/routes_system.dart';
import 'package:scan_qr/templates/dialogs/custom_dialogs.dart';
import 'package:scan_qr/templates/general_scaffords/general_scafford_screen.dart';
import 'package:scan_qr/templates/navbars/navbar_widget.dart';
import 'package:scan_qr/views/dashboard/outbound/outbound_category_scan/outbound_category_scan_screen.dart';

class OutBoundScreen extends StatefulWidget {
  const OutBoundScreen({super.key});

  @override
  State<OutBoundScreen> createState() => _OutBoundScreenState();
}

class _OutBoundScreenState extends State<OutBoundScreen> {
  final GlobalKey<NavigatorState> _nestedNavKey = GlobalKey<NavigatorState>();
  String? _currentNestedRoute;

  // Add state for camera active status
  bool _cameraActive = true;
  bool _isSaving = false;

  // Create a key to access the scan screen state
  final GlobalKey<OutboundCategoryScanScreenState> _scanScreenKey =
      GlobalKey<OutboundCategoryScanScreenState>();

  bool checkIsSubScreen() {
    return _currentNestedRoute != AppRouter.outboundScan;
  }

  void _handleBackButton() {
    final navigator = _nestedNavKey.currentState;
    if (navigator != null && navigator.canPop()) {
      // Nếu nested navigator có thể pop, thực hiện pop
      navigator.pop();
    } else if (_currentNestedRoute != AppRouter.outboundMain) {
      // Nếu hiện tại không phải ở màn hình chính của OutBound, thì quay lại màn hình đó
      navigator?.pushReplacementNamed(AppRouter.outboundMain);
    } else {
      // Chỉ pop ra ngoài OutBound nếu đang ở màn hình outboundMain
      Navigator.of(context).pop();
    }
  }

  // Function to toggle camera
  void _toggleCamera() {
    setState(() {
      _cameraActive = !_cameraActive;
    });

    // Forward the action to the scan screen if it exists
    final scanScreenState = _scanScreenKey.currentState;
    if (scanScreenState != null) {
      scanScreenState.toggleCamera();
    }
  }

  // Function to clear data
  void _clearScannedData() {
    // Forward the action to the scan screen if it exists
    final scanScreenState = _scanScreenKey.currentState;
    if (scanScreenState != null) {
      scanScreenState.clearScannedData();
    }
  }

  void _saveScanneData(){
    final scanScreenState = _scanScreenKey.currentState;
    if (scanScreenState != null) {
      scanScreenState.saveScannedData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScreenScaffold(
      title: Row(
        children: [
          Expanded(
            child: Align(
              alignment:
                  checkIsSubScreen() ? Alignment(-0.5,0) : Alignment.center,
              child: const Text(
                "OUTBOUND CATEGORY",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      isSubScreen: false,
      showBackButton: checkIsSubScreen(),
      actions: [
        if (_currentNestedRoute == AppRouter.outboundScan)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
              icon: _isSaving 
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : const Icon(Icons.save, color: Colors.black),
              onPressed: _isSaving ? null : _saveScanneData,
              tooltip: "Save scanned data",
              ),
              IconButton(
                icon: Icon(
                  _cameraActive ? Icons.camera_alt : Icons.camera_alt_outlined,
                ),
                onPressed: _toggleCamera,
                tooltip: _cameraActive ? "Turn off camera" : "Turn on camera",
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  await CustomDialog.warning(
                    context: context,
                    title: "Warning",
                    message:
                        "Bạn có chắc chắn muốn xóa tất cả dữ liệu đã quét?",
                    confirmLabel: null,
                    cancelLabel: null,
                    onConfirm: () {
                      _clearScannedData();
                    },
                  );
                },
                tooltip: "Clear all scanned items",
              ),
              IconButton(
                icon: const Icon(Icons.directions_run),
                onPressed: () async {
                  await CustomDialog.warning(
                    context: context,
                    title: "Warning",
                    message:
                        "Are you sure about deleting all the scanned data?",
                    confirmLabel: null,
                    cancelLabel: null,
                    onConfirm: () {
                      _handleBackButton();
                    },
                  );
                },
              ),
            ],
          ),
      ],

      body: Navigator(
        key: _nestedNavKey,
        observers: [
          NestedNavigatorObserver(
            onNavigation: (Route<dynamic>? route) {
              if (!mounted) return;
              if (route is MaterialPageRoute && route.settings.name != null) {
                final routeName = route.settings.name!;
                if (routeName.startsWith('/outbound-')) {
                  setState(() {
                    _currentNestedRoute = routeName;
                  });
                } else {
                  setState(() {
                    _currentNestedRoute = null;
                  });
                }
              }
            },
          ),
        ],
        initialRoute: AppRouter.outboundMain,
        onGenerateRoute: (RouteSettings settings) {
          // Sử dụng route manager cho nested routes
          if (settings.name == AppRouter.outboundScan) {
            // Truyền các tham số cần thiết
            final args = {
              'key': _scanScreenKey,
              'onCameraToggle': () {
                setState(() {
                  _cameraActive = !_cameraActive;
                });
              },
              'onClearData': () {
                // Cập nhật state nếu cần
              },
            };

            final updatedSettings = RouteSettings(
              name: settings.name,
              arguments: args,
            );

            return AppRouter.onGenerateOutboundRoute(updatedSettings);
          }

          return AppRouter.onGenerateOutboundRoute(settings);
        },
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}

class NestedNavigatorObserver extends NavigatorObserver {
  final void Function(Route<dynamic>?) onNavigation;

  NestedNavigatorObserver({required this.onNavigation});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('didPush: ${route.settings.name}');
    super.didPush(route, previousRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onNavigation(route);
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint(
      'didPop: ${route.settings.name} -> ${previousRoute?.settings.name}',
    );
    super.didPop(route, previousRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onNavigation(previousRoute);
    });
  }
}
