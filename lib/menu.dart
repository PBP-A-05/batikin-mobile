// lib/screens/home/my_home_page.dart

import 'package:batikin_mobile/screens/placeholder/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:batikin_mobile/screens/profile/profile_screen.dart';
import 'package:batikin_mobile/constants/colors.dart'; // Ensure this path is correct

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  // List of pages to display in each tab
  final List<Widget> _pages = const [
    PlaceholderPage(
      title: "test",
    ),
    PlaceholderPage(
      title: "test",
    ),
    PlaceholderPage(
      title: "test",
    ),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16.0), // Margin to float the navbar
        decoration: BoxDecoration(
          color: Colors.white, // Navbar background color
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Subtle shadow
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4), // Shadow position
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              30.0), // Match the container's border radius
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed, // Fixed navbar style
            backgroundColor: Colors
                .transparent, // Transparent background to avoid overriding container color
            elevation: 0, // Remove BottomNavigationBar shadow
            selectedItemColor: AppColors.coklat3, // Color for selected items
            unselectedItemColor:
                AppColors.coklat1Rgba, // Color for unselected items
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
