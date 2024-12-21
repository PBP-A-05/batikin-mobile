// lib/screens/profile/alamat_screen.dart
import 'package:batikin_mobile/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/profile_model.dart';
import 'package:batikin_mobile/services/alamat_service.dart';
import 'package:batikin_mobile/screens/profile/edit_alamat_page.dart';
import 'package:batikin_mobile/screens/profile/add_alamat_page.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/services/auth_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AlamatPage extends StatefulWidget {
  final List<Address> initialAddresses;

  const AlamatPage({super.key, required this.initialAddresses});

  @override
  _AlamatPageState createState() => _AlamatPageState();
}

class _AlamatPageState extends State<AlamatPage> {
  late List<Address> addresses;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    addresses = widget.initialAddresses;
  }

  Future<void> _fetchAddresses() async {
    setState(() {
      _isLoading = true;
    });

    // Obtain CookieRequest from Provider
    CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
    AuthService authService = AuthService(request);

    Profile? profile = await authService.getUserInfo();

    if (profile != null) {
      setState(() {
        addresses = profile.addresses;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showToast(context, 'Gagal memuat alamat.', type: ToastType.alert);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed canAddMore condition to always show the FAB
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada alamat tersedia.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchAddresses,
                  child: ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return ListTile(
                        leading: const Icon(Icons.home),
                        title: Text(address.title),
                        subtitle: Text(address.address),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.edit, color: AppColors.coklat2),
                          onPressed: () async {
                            bool? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditAlamatPage(address: address),
                              ),
                            );

                            if (result == true) {
                              await _fetchAddresses();
                              showToast(context, 'Alamat berhasil diperbarui.',
                                  type: ToastType.success);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (addresses.length >= 3) {
            showToast(context, 'Maksimal 3 alamat sudah tercapai.',
                type: ToastType.alert);
            return;
          }

          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAlamatPage(),
            ),
          );

          if (result == true) {
            await _fetchAddresses();
            showToast(context, 'Alamat berhasil ditambahkan.',
                type: ToastType.success);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white, // Set the icon color to white
        ),
        backgroundColor: AppColors.coklat2,
      ),
    );
  }
}
