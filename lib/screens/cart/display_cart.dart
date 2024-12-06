import 'package:flutter/material.dart';

class DisplayCart extends StatelessWidget {
  const DisplayCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: const Center(
        child: Text('This is the cart page'),
      ),
    );
  }
}