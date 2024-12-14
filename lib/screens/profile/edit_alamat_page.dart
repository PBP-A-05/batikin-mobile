// lib/screens/profile/edit_alamat_page.dart
import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/profile_model.dart';
import 'package:batikin_mobile/services/alamat_service.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class EditAlamatPage extends StatefulWidget {
  final Address address;

  const EditAlamatPage({super.key, required this.address});

  @override
  _EditAlamatPageState createState() => _EditAlamatPageState();
}

class _EditAlamatPageState extends State<EditAlamatPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.address.title);
    _addressController = TextEditingController(text: widget.address.address);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Address updatedAddress = Address(
        id: widget.address.id,
        title: _titleController.text,
        address: _addressController.text,
      );

      // Obtain CookieRequest from Provider
      CookieRequest request =
          Provider.of<CookieRequest>(context, listen: false);

      bool success = await AlamatService.updateAddress(request, updatedAddress);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        showToast(context, 'Alamat berhasil diperbarui.',
            type: ToastType.success);
        Navigator.pop(context, true);
      } else {
        showToast(context, 'Gagal memperbarui alamat.', type: ToastType.alert);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Alamat'),
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
                      onPressed: _updateAddress,
                      child: const Text('Perbarui'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
