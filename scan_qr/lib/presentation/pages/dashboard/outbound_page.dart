import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_bloc.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_event.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_state.dart';
import 'package:scan_qr/presentation/pages/dashboard/outbound_category_scan_page.dart';
import 'package:scan_qr/presentation/routes/app_router.dart';
import 'package:scan_qr/presentation/widgets/dialogs/custom_dialogs.dart';
import 'package:scan_qr/presentation/widgets/navigation/navbar_widget.dart';
import 'package:scan_qr/presentation/widgets/scaffolds/general_scaffold.dart';

class OutboundPage extends StatefulWidget {
  const OutboundPage({super.key});

  @override
  State<OutboundPage> createState() => _OutboundPageState();
}

class _OutboundPageState extends State<OutboundPage> {
  final GlobalKey<NavigatorState> _nestedNavKey = GlobalKey<NavigatorState>();
  String? _currentNestedRoute;

  final GlobalKey<OutboundCategoryScanPageState> _scanScreenKey =
      GlobalKey<OutboundCategoryScanPageState>();

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

  @override
  Widget build(BuildContext context) {
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
        return GeneralScreenScaffold(
          title: Row(
            children: [
              Expanded(
                child: Align(
                  alignment:
                      checkIsSubScreen() ? const Alignment(-0.5, 0) : Alignment.center,
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
                    icon: state is ScanSaving
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Icon(Icons.save, color: Colors.black),
                    onPressed: state is ScanSaving
                        ? null
                        : () {
                            if (state is ScanActive && state.scannedData.isNotEmpty) {
                              context.read<ScanBloc>().add(
                                SaveScannedDataRequested(state.scannedData),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No data to save'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                    tooltip: "Save scanned data",
                  ),
                  IconButton(
                    icon: Icon(
                      state is ScanActive && state.cameraActive
                          ? Icons.camera_alt
                          : Icons.camera_alt_outlined,
                    ),
                    onPressed: () {
                      context.read<ScanBloc>().add(ToggleCameraRequested());
                    },
                    tooltip: state is ScanActive && state.cameraActive
                        ? "Turn off camera"
                        : "Turn on camera",
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await CustomDialog.warning(
                        context: context,
                        title: "Warning",
                        message: "Bạn có chắc chắn muốn xóa tất cả dữ liệu đã quét?",
                        confirmLabel: null,
                        cancelLabel: null,
                        onConfirm: () {
                          context.read<ScanBloc>().add(ClearScannedDataRequested());
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
                       message: "Are you sure about deleting all the scanned data?",
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
                   context.read<ScanBloc>().add(ToggleCameraRequested());
                 },
                 'onClearData': () {
                   context.read<ScanBloc>().add(ClearScannedDataRequested());
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
     },
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