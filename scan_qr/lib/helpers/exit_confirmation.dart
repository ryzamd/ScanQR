import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_qr/templates/dialogs/custom_dialogs.dart';

class ExitConfirmationHelper {

  static Widget wrapWithExitConfirmation({
    required BuildContext context,
    required Widget child,
    bool isRootScreen = false,
  }) {
    return PopScope(
      canPop: !isRootScreen,
      onPopInvokedWithResult: (didPop , result) async {
        if(didPop){
          return;
        }

        if(isRootScreen){
          result = await CustomDialog.exit(context: context,
          title: "EXIT",
          message: "Do you want to Exit ?");
          if(result == true){
            SystemNavigator.pop();
          }
        }
      } ,
      child: child,
    );
  }
}