import 'package:flutter/material.dart';
import 'package:batikin_mobile/widgets/gradient_border.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color textColor;
  final Gradient borderGradient;

  const CustomGradientButton({
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.textColor,
    required this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: borderGradient,
        strokeWidth: 2.0,
        radius: 8.0,
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
