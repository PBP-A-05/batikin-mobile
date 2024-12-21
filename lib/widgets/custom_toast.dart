// lib/widgets/custom_toast.dart
import 'package:batikin_mobile/constants/colors.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final ToastType type;

  const CustomToast({Key? key, required this.message, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Gradient borderGradient;
    Color textColor;
    Color backgroundColor;

    switch (type) {
      case ToastType.success:
        borderGradient = AppColors.gradientCoklat;
        textColor = AppColors.coklat2;
        backgroundColor = Colors.white;
        break;
      case ToastType.alert:
        borderGradient = AppColors.gradientCoklat;
        textColor = Colors.red;
        backgroundColor = Colors.white;
        break;
      case ToastType.info:
      default:
        borderGradient = AppColors.gradientCoklat;
        textColor = Colors.white;
        backgroundColor = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(2.0), // Border width
      decoration: BoxDecoration(
        gradient: borderGradient,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: textColor, fontSize: 16.0),
        ),
      ),
    );
  }
}
