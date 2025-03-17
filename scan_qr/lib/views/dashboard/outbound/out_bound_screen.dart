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

  bool _cameraActive = true;
  bool _isSaving = false;

  final GlobalKey<OutboundCategoryScanScreenState> _scanScreenKey =
      GlobalKey<OutboundCategoryScanScreenState>();

  bool checkIsSubScreen() {
    return _currentNestedRoute != AppRouter.outboundScan;
  }

  void _handleBackButton() {
    final navigator = _nestedNavKey.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
    } else if (_currentNestedRoute != AppRouter.outboundMain) {
      navigator?.pushReplacementNamed(AppRouter.outboundMain);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _toggleCamera() {
    setState(() {
      _cameraActive = !_cameraActive;
    });

    final scanScreenState = _scanScreenKey.currentState;
    if (scanScreenState != null) {
      scanScreenState.toggleCamera();
    }
  }

  void _clearScannedData() {
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
          if (settings.name == AppRouter.outboundScan) {
            final args = {
              'key': _scanScreenKey,
              'onCameraToggle': () {
                setState(() {
                  _cameraActive = !_cameraActive;
                });
              },
              'onClearData': () {
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
