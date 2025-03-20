import 'package:flutter/material.dart';

enum Flavor {
  qcManager,
  warehouseInbound,
  warehouseOutbound,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String appTitle;
  final ThemeData theme;
  
  static FlavorConfig? _instance;
  
  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required String appTitle,
    required ThemeData theme,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      name: name,
      appTitle: appTitle,
      theme: theme,
    );
    return _instance!;
  }
  
  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.appTitle,
    required this.theme,
  });
  
  static FlavorConfig get instance {
    return _instance!;
  }
  
  static bool isQcManager() => _instance?.flavor == Flavor.qcManager;
  static bool isWarehouseInbound() => _instance?.flavor == Flavor.warehouseInbound;
  static bool isWarehouseOutbound() => _instance?.flavor == Flavor.warehouseOutbound;
}