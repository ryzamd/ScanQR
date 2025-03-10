import 'dart:ui';

class ShareScannerBusinessStyles {
  static Color adjustOpacity(Color color, double opacity) {
    return color.withValues(
      red: (opacity * 255).toDouble(),
      blue: (opacity * 255).toDouble(),
      green: (opacity * 255).toDouble(),
      alpha: (opacity * 255).toDouble(),
    );
  }
}
