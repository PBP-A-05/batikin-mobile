// lib/screens/profile.dart
import 'package:batikin_mobile/screens/profile/edit_profile_screen.dart';
import 'package:batikin_mobile/screens/profile/history_booking_page.dart';
import 'package:batikin_mobile/screens/profile/pemesanan_screen.dart';
import 'package:batikin_mobile/widgets/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:batikin_mobile/widgets/custom_button.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/services/auth_service.dart';
import 'package:batikin_mobile/screens/authentication/login_screen.dart';
import 'package:batikin_mobile/screens/authentication/register_screen.dart';
import 'package:batikin_mobile/screens/profile/alamat_screen.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Profile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    final authService = AuthService(request);
    _profileFuture = authService.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final authService = AuthService(request);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
            color: AppColors.coklat2,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.coklat2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: request.loggedIn
            ? FutureBuilder<Profile?>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data found.'));
                  } else {
                    final profile = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Picture
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOizmxkQV5rf4N9ayOC3pojndp0nzIDAFUtg&s',
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, ${profile.firstName} ${profile.lastName}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Username: ${profile.username}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Phone: ${profile.phoneNumber}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: AppColors.coklat2,
                              tooltip: 'Edit Profile',
                              onPressed: () async {
                                // Navigate to EditProfilePage and await the result
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfilePage(profile: profile),
                                  ),
                                );
                                if (result == true) {
                                  // If update was successful, refetch profile data
                                  setState(() {
                                    _profileFuture = authService.getUserInfo();
                                  });
                                  // Show success toast
                                  showToast(
                                    context,
                                    'Profile updated successfully!',
                                    type: ToastType.success,
                                    gravity: ToastGravity.BOTTOM_RIGHT,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Logout Button
                        CustomButton(
                          text: 'Logout',
                          onPressed: () async {
                            final success = await authService.logout();
                            if (success) {
                              showToast(
                                context,
                                'Successfully logged out!',
                                type: ToastType.success,
                                gravity: ToastGravity.BOTTOM_RIGHT,
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            } else {
                              showToast(
                                context,
                                'Logout failed!',
                                type: ToastType.alert,
                                gravity: ToastGravity.BOTTOM_RIGHT,
                              );
                            }
                          },
                          width: double.infinity,
                          height: 50.0,
                          backgroundColor: Colors.red,
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 20),
                        // History Pembelian
                        ListTile(
                          leading: const Icon(Icons.history),
                          title: const Text('History Pembelian'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HistoryPemesananPage(),
                              ),
                            );
                          },
                        ),
                        // History Booking
                        ListTile(
                          leading: const Icon(Icons.book_online),
                          title: const Text('History Booking'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HistoryBookingPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text('Daftar Alamat'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlamatPage(
                                  initialAddresses: profile.addresses,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with Login and Register
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Login',
                          backgroundColor: AppColors.coklat1,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomGradientButton(
                          text: 'Register',
                          backgroundColor: const Color(
                              0xFFF6F6F6), // Background color F6F6F6
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          width: double.infinity,
                          height: 50.0,
                          textColor: AppColors.coklat1, // Text color 754B0B
                          borderGradient:
                              AppColors.gradientCoklat, // Gradient border
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Purchase History (shows a toast when tapped)
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('History Pembelian'),
                    onTap: () {
                      showToast(
                        context,
                        'Please login to view your purchase history.',
                        type: ToastType.alert,
                        gravity: ToastGravity.BOTTOM_RIGHT,
                      );
                    },
                  ),
                  // Booking History (shows a toast when tapped)
                  ListTile(
                    leading: const Icon(Icons.book_online),
                    title: const Text('History Booking'),
                    onTap: () {
                      showToast(
                        context,
                        'Please login to view your booking history.',
                        type: ToastType.alert,
                        gravity: ToastGravity.BOTTOM_RIGHT,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
