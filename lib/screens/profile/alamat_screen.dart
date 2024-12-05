// lib/screens/profile/alamat_screen.dart
import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/profile_model.dart';

class AlamatPage extends StatelessWidget {
  final List<Address> addresses;

  const AlamatPage({super.key, required this.addresses});

  @override
  Widget build(BuildContext context) {
    // Debug prints
    print('AlamatPage received ${addresses.length} addresses.');
    for (var addr in addresses) {
      print(
          'Address ID: ${addr.id}, Title: ${addr.title}, Address: ${addr.address}');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: addresses.isEmpty
          ? const Center(
              child: Text(
                'No addresses available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(address.title),
                  subtitle: Text(address.address),
                );
              },
            ),
    );
  }
}
