import 'package:flutter/material.dart';
import 'package:scan_qr/enums/global_enums.dart';

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
        titleColor = Colors.amber.shade900; // Deep yellow
        confirmButtonColor = Colors.amber.shade900;
        break;
      case DialogType.success:
        titleColor = Colors.green;
        confirmButtonColor = Colors.green;
        break;
      case DialogType.notice:
        titleColor = Colors.black;
        confirmButtonColor = Colors.black;
        break;
    }

    // Calculate button width based on isHasCancelButton
    double confirmButtonWidth = isHasCancelButton == true ? 115 : 250;
    const double buttonWidth = 115.0;
    const double buttonHeight = 40.0;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        //       return AlertDialog(
        //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //         insetPadding: const EdgeInsets.all(25),
        //         contentPadding: const EdgeInsets.all(10),
        //         titlePadding: const EdgeInsets.only(top: 15, left: 15),
        //         actionsPadding: const EdgeInsets.all(15),
        //         title: SizedBox(
        //           child: Text(
        //             title.toUpperCase(),
        //             style: TextStyle(
        //               color: titleColor,
        //               fontSize: 18,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //         content: Padding(
        //           padding: const EdgeInsets.all(10),
        //           child: Text(
        //             message,
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               fontSize: 16,
        //             ),
        //           ),
        //         ),
        //         actions: <Widget>[
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               if (isHasCancelButton == true) ...[
        //                 SizedBox(
        //                   width: 120,
        //                   height: 40,
        //                   child: ElevatedButton(
        //                     style: ButtonStyle(
        //                       backgroundColor: WidgetStateProperty.all<Color>(
        //                         Colors.grey,
        //                       ),
        //                       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        //                         RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(5),
        //                         ),
        //                       ),
        //                     ),
        //                     child: cancelLabel ?? const Text(
        //                       'CANCEL',
        //                       style: TextStyle(
        //                         color: Colors.black,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                     onPressed: () {
        //                       onCancel?.call();
        //                       Navigator.of(context).pop(false);
        //                     },
        //                   ),
        //                 ),
        //                 const SizedBox(width: 40),
        //               ],

        //               SizedBox(
        //                 width: confirmButtonWidth,
        //                 height: 40,
        //                 child: ElevatedButton(
        //                   style: ButtonStyle(
        //                     backgroundColor: WidgetStateProperty.all<Color>(
        //                       confirmButtonColor,
        //                     ),
        //                     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        //                       RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(5),
        //                       ),
        //                     ),
        //                   ),
        //                   child: confirmLabel ?? const Text(
        //                     'CONFIRM',
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   onPressed: () {
        //                     onConfirm?.call();
        //                     Navigator.of(context).pop(true);
        //                   },
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // }

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
}
