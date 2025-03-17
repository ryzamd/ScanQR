// scanned_item_model.dart
class ScannedItem {
  final String code;
  final String status;
  final String quantity;
  final String total;

  ScannedItem({
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

  factory ScannedItem.fromJson(Map<String, dynamic> json) {
    return ScannedItem(
      code: json['code'],
      status: json['status'],
      quantity: json['quantity'],
      total: json['total'],
    );
  }
}