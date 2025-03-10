import 'package:flutter/material.dart';
import 'package:scan_qr/enums/global_enums.dart';

class CustomDialog {
  static Future<bool?> show({
    required BuildContext context,
    required Widget title,
    required String message,
    DialogType type = DialogType.confirm,
    Widget? confirmLabel,
    Widget? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: const EdgeInsets.all(35),
          title: Row(children: [const SizedBox(width: 8), title]),
          content: Text(message),
          actions: <Widget>[
            Row(
              children: [
                // Cancel button
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all<Size>(
                      const Size(110, 40),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      type == DialogType.confirm ? Colors.red : Colors.grey,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  child: cancelLabel ?? const Text('CANCEL'),
                  onPressed: () {
                    onCancel?.call();
                    Navigator.of(context).pop(false);
                  },
                ),
                const SizedBox(width: 20),
                // Confirm button
                ElevatedButton(
                  style: ButtonStyle(
                    maximumSize: WidgetStateProperty.all<Size>(
                      const Size(120, 40),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      type == DialogType.confirm ? Colors.blue : Colors.red,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  child: confirmLabel ?? const Text('CONFIRM'),
                  onPressed: () {
                    onConfirm?.call();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Confirm dialog shortcut
  static Future<bool?> confirm({
    required BuildContext context,
    required Widget title,
    required String message,
    Widget? confirmLabel,
    Widget? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.confirm,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  // Warning dialog shortcut
  static Future<bool?> warning({
    required BuildContext context,
    required Widget title,
    required String message,
    Widget? confirmLabel,
    Widget? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.warning,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  // Error dialog shortcut
  static Future<bool?> error({
    required BuildContext context,
    required Widget title,
    required String message,
    Widget? confirmLabel,
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.error,
      confirmLabel: confirmLabel,
      onConfirm: onConfirm,
    );
  }

  // Success dialog shortcut
  static Future<bool?> success({
    required BuildContext context,
    required Widget title,
    required String message,
    Widget? confirmLabel,
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.success,
      confirmLabel: confirmLabel,
      onConfirm: onConfirm,
    );
  }
}
