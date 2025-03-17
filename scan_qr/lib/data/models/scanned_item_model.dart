import 'package:scan_qr/domain/entities/scanned_item.dart';

class ScannedItemModel {
  final String code;
  final String status;
  final String quantity;
  final String total;

  ScannedItemModel({
    required this.code,
    required this.status,
    required this.quantity,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'quantity': quantity,
      'total': total,
    };
  }

  factory ScannedItemModel.fromJson(Map<String, dynamic> json) {
    return ScannedItemModel(
      code: json['code'],
      status: json['status'],
      quantity: json['quantity'],
      total: json['total'],
    );
  }

  ScannedItem toEntity() {
    return ScannedItem(
      code: code,
      status: status,
      quantity: quantity,
      total: total,
    );
  }

  factory ScannedItemModel.fromEntity(ScannedItem item) {
    return ScannedItemModel(
      code: item.code,
      status: item.status,
      quantity: item.quantity,
      total: item.total,
    );
  }
}
