// lib/main.dart
import 'package:batikin_mobile/menu.dart';
import 'package:batikin_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batikin_mobile/screens/authentication/login_screen.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/screens/cart/display_cart.dart'; // Import the cart page
import 'package:batikin_mobile/screens/placeholder/placeholder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Batikin E-Commerce',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              textStyle:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        home: const MyHomePage(
          username: 'test',
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/cart': (context) => const DisplayCart(), // Add the cart route
          '/placeholder': (context) => const ProfilePage(),
          '/placerholder': (context) => const ProfilePage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
