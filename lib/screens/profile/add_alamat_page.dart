// lib/screens/profile/add_alamat_page.dart
import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/profile_model.dart';
import 'package:batikin_mobile/services/alamat_service.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddAlamatPage extends StatefulWidget {
  const AddAlamatPage({super.key});

  @override
  _AddAlamatPageState createState() => _AddAlamatPageState();
}

class _AddAlamatPageState extends State<AddAlamatPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _addAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Address newAddress = Address(
        id: 0, // ID will be set by the backend
        title: _titleController.text,
        address: _addressController.text,
      );

      // Obtain CookieRequest from Provider
      CookieRequest request =
          Provider.of<CookieRequest>(context, listen: false);

      bool success = await AlamatService.addAddress(request, newAddress);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        showToast(context, 'Alamat berhasil ditambahkan.',
            type: ToastType.success);
        Navigator.pop(context, true);
      } else {
        showToast(context, 'Gagal menambahkan alamat.', type: ToastType.alert);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Alamat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan judul.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Alamat'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan alamat.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addAddress,
                      child: const Text('Tambah'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
