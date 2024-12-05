// lib/constants/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Solid Colors
  static const Color coklat1 = Color(0xFF754B0B); // #754B0B
  static const Color coklat2 = Color(0xFF4C3108); // #4C3108
  static const Color coklat3 = Color(0xFF714503); // #714503

  // RGBA Colors
  static const Color coklat1Rgba =
      Color.fromRGBO(117, 75, 11, 0.25); // rgba(117, 75, 11, 0.25)

  // Gradient Colors
  static const Gradient gradientCoklat = LinearGradient(
    colors: [Color(0xFF754B0B), Color(0xFFDB8C15)], // #754B0B to #DB8C15
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient bgGradientCoklat = LinearGradient(
    colors: [Color(0xFF754B0B), Color(0xFFDB8C15)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Border Colors
  static const BorderSide borderCoklatRgba = BorderSide(
    color: Color.fromRGBO(117, 75, 11, 0.25), // rgba(117, 75, 11, 0.25)
    width: 1.0,
  );
}
