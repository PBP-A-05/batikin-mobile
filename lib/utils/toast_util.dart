import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:batikin_mobile/widgets/custom_toast.dart';

enum ToastType { success, alert, info }

void showToast(BuildContext context, String message,
    {ToastType type = ToastType.info,
    ToastGravity gravity = ToastGravity.BOTTOM}) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Padding(
    padding: const EdgeInsets.only(bottom: 30.0), // Adjust the value as needed
    child: CustomToast(message: message, type: type),
  );
  fToast.showToast(
    child: toast,
    gravity: gravity,
    toastDuration: Duration(seconds: 2),
  );
}
