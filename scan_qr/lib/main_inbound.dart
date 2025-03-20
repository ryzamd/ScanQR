import 'package:flutter/material.dart';
import 'package:scan_qr/flavors.dart';
import 'package:scan_qr/main.dart';

void main() {
  // Khởi tạo flavor configuration
  FlavorConfig(
    flavor: Flavor.warehouseInbound, // hoặc warehouseInbound, warehouseOutbound
    name: "Inbound Manager", // Tên phù hợp
    appTitle: "Inbound Manager App", // Tiêu đề ứng dụng
    theme: ThemeData(
      primaryColor: Colors.blue, // Màu sắc chủ đạo cho từng ứng dụng
      // Các thiết lập theme khác
    ),
  );
  
  // Khởi tạo dependencies
  //setupDependencies();
  
  // Chạy ứng dụng
  runApp(const MyApp());
}