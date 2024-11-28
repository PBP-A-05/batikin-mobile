// lib/screens/placeholder/placeholder.dart

import 'package:flutter/material.dart';
import 'package:batikin_mobile/constant/colors.dart'; // Ensure this path is correct

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'This is the $title Page',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.coklat2,
          ),
        ),
      ),
    );
  }
}
