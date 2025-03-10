import 'package:flutter/material.dart';
import 'package:scan_qr/templates/dialogs/custom_dialogs.dart';
import 'package:scan_qr/templates/general_scaffords/general_scafford_screen.dart';
import 'package:scan_qr/templates/navbars/navbar_widget.dart';
import 'package:scan_qr/views/dashboard/outbound/out_bound_component_widgets.dart';
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

  // Create a key to access the scan screen state
  final GlobalKey<OutboundCategoryScanScreenState> _scanScreenKey =
      GlobalKey<OutboundCategoryScanScreenState>();

  void _handleBackButton() {
    final navigator = _nestedNavKey.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
    } else {
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

  @override
  Widget build(BuildContext context) {
    return GeneralScreenScaffold(
      title: const Text(
        "OUTBOUND CATEGORY",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      showBackButton: true,
      isSubScreen: false,
      actions: [
        if (_currentNestedRoute == '/outbound-scan')
          Row(
            mainAxisSize: MainAxisSize.min, // Giữ layout gọn nhất có thể
            children: [
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
                  // Thêm một anonymous async function
                  final result = await CustomDialog.warning(
                    context: context,
                    title: Text(
                      'WARNING',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    message:
                        'Bạn có chắc chắn muốn xóa tất cả dữ liệu đã quét?',
                    confirmLabel: Text(
                      'CONFIRM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    cancelLabel: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
              IconButton(
                icon: const Icon(Icons.directions_run),
                onPressed: () async {
                  // Thêm một anonymous async function
                  final result = await CustomDialog.warning(
                    context: context,
                    title: Text(
                      'WARNING',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    message: 'Bạn có chắc chắn muốn trở lại?',
                    confirmLabel: Text(
                      'CONFIRM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    cancelLabel: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onConfirm: () {
                      _handleBackButton(); // Gọi hàm xóa dữ liệu
                    },
                  );

                  if (result == true) {
                    // Nếu người dùng đã xác nhận, thực hiện xóa
                    _handleBackButton();
                  }
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
              // Sau khi push/pop xong (post frame callback), ta mới setState
              if (!mounted) return;
              if (route is MaterialPageRoute && route.settings.name != null) {
                final routeName = route.settings.name!;
                // Bỏ qua nếu routeName == '/' (của top-level)
                // hoặc routeName == null
                if (routeName.startsWith('/outbound-')) {
                  setState(() {
                    _currentNestedRoute = routeName;
                  });
                } else {
                  // Nếu là route top-level hoặc popup => đặt _currentNestedRoute = null
                  setState(() {
                    _currentNestedRoute = null;
                  });
                }
              }
            },
          ),
        ],
        initialRoute: '/outbound-main',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/outbound-main':
              return MaterialPageRoute(
                settings: settings,
                builder:
                    (context) =>
                        OutBoundComponentWidgets.buildSelectType(context),
              );
            case '/outbound-scan':
              return MaterialPageRoute(
                settings: settings,
                builder:
                    (context) => OutboundCategoryScanScreen(
                      key: _scanScreenKey,
                      onCameraToggle: () {
                        setState(() {
                          _cameraActive = !_cameraActive;
                        });
                      },
                      onClearData: () {
                        // If needed, update any state in the parent related to cleared data
                      },
                    ),
              );
            default:
              return MaterialPageRoute(
                settings: settings,
                builder:
                    (context) =>
                        OutBoundComponentWidgets.buildSelectType(context),
              );
          }
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
    // Gọi callback sau khi push hoàn tất
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
