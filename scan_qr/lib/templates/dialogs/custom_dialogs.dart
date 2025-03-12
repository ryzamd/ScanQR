import 'package:flutter/material.dart';
import 'package:scan_qr/enums/global_enums.dart';
import 'package:scan_qr/utilites/contants/style_contants.dart';

class CustomDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    bool? isHasCancelButton = true,
    DialogType type = DialogType.confirm,
    Widget? confirmLabel,
    Widget? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    // Define colors based on dialog type
    Color titleColor;
    Color confirmButtonColor;

    switch (type) {
      case DialogType.confirm:
        titleColor = Colors.blue;
        confirmButtonColor = Colors.blue;
        break;
      case DialogType.warning:
        titleColor = Colors.red;
        confirmButtonColor = Colors.red;
        break;
      case DialogType.error:
        titleColor = Colors.amber.shade900;
        confirmButtonColor = Colors.amber.shade900;
        break;
      case DialogType.success:
        titleColor = Colors.green;
        confirmButtonColor = Colors.green;
        break;
      case DialogType.notice:
        titleColor = ColorsConstants.primaryColor;
        confirmButtonColor = ColorsConstants.primaryColor;
        break;
      case DialogType.exit:
        titleColor = Colors.red;
        confirmButtonColor = Colors.red;
    }

    // Calculate button width based on isHasCancelButton
    double confirmButtonWidth = isHasCancelButton == true ? 115 : 250;
    const double buttonWidth = 115.0;
    const double buttonHeight = 40.0;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(35),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 15, left: 15),
                  child: Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Message section - takes available space
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(message, textAlign: TextAlign.center),
                    ),
                  ),
                ),

                // Button section
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isHasCancelButton == true) ...[
                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.grey,
                              ),
                              shape: WidgetStateProperty.all<
                                RoundedRectangleBorder
                              >(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              minimumSize: WidgetStateProperty.all<Size>(
                                const Size(buttonWidth, buttonHeight),
                              ),
                            ),
                            child:
                                cancelLabel ??
                                const Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            onPressed: () {
                              onCancel?.call();
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],

                      SizedBox(
                        width: confirmButtonWidth,
                        height: buttonHeight,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              confirmButtonColor,
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                            minimumSize: WidgetStateProperty.all<Size>(
                              const Size(buttonWidth, buttonHeight),
                            ),
                          ),
                          child:
                              confirmLabel ??
                              const Text(
                                'CONFIRM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          onPressed: () {
                            onConfirm?.call();
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Confirm dialog shortcut
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    bool? isHasCancelButton = true,
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
      isHasCancelButton: isHasCancelButton,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  // Warning dialog shortcut
  static Future<bool?> warning({
    required BuildContext context,
    required String title,
    required String message,
    bool? isHasCancelButton = true,
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
      isHasCancelButton: isHasCancelButton,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  // Error dialog shortcut
  static Future<bool?> error({
    required BuildContext context,
    required String title,
    required String message,
    bool? isHasCancelButton = true,
    Widget? confirmLabel,
    Widget? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.error,
      isHasCancelButton: isHasCancelButton,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  // Success dialog shortcut
  static Future<bool?> success({
    required BuildContext context,
    required String title,
    required String message,
    bool? isHasCancelButton = true,
    Widget? confirmLabel,
    Widget? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.success,
      isHasCancelButton: isHasCancelButton,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  // Notice dialog shortcut
  static Future<bool?> notice({
    required BuildContext context,
    required String title,
    required String message,
    bool? isHasCancelButton = true,
    Widget? confirmLabel,
    Widget? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.notice,
      isHasCancelButton: isHasCancelButton,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

    static Future<bool?> exit({
    required BuildContext context,
    required String title,
    required String message,
    bool? isHasCancelButton = true,
    Widget? confirmLabel,
    Widget? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: DialogType.exit,
      isHasCancelButton: isHasCancelButton,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }
}
