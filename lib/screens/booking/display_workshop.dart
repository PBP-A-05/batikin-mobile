import 'package:batikin_mobile/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:batikin_mobile/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batikin_mobile/models/workshop.dart';
import 'package:batikin_mobile/screens/booking/workshop_detail.dart';
//import 'dart:ui';

class DisplayWorkshop extends StatefulWidget {
  final String initialCategory;

  const DisplayWorkshop({super.key, required this.initialCategory});

  @override
  _DisplayWorkshopState createState() => _DisplayWorkshopState();
}

class _DisplayWorkshopState extends State<DisplayWorkshop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;
  List<Workshop> workshops = [];
  bool isLoading = true;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    fetchWorkshops();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchWorkshops() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/workshops/json/'), // Endpoint untuk data workshop
      );
      if (response.statusCode == 200) {
        setState(() {
          workshops = workshopFromJson(
              response.body); // Parsing JSON menjadi objek workshop
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Workshop> getFilteredWorkshops() {
    return workshops
        .where((workshop) => workshop.fields.title == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Fixed AppBar with shadow
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.coklat1.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Container(
                    height: kToolbarHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.coklat1), //nambah const
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          //nambah const
                          child: Center(
                            child: Text(
                              'Batikin',
                              style: TextStyle(
                                fontFamily: AppFonts.javaneseText,
                                fontSize: 24,
                                color: AppColors.coklat1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Floating Navigation Bar
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    selectedItemColor: AppColors.coklat3,
                    unselectedItemColor: AppColors.coklat1Rgba,
                    selectedLabelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
            ),
          ),
        ));
  }

  Widget _buildFilterButton(String category, String label) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        // Reset animation dan jalankan kembali
        _controller.reset();
        _controller.forward();
      },
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: AppColors.coklat2,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.bgGradientCoklat : null,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopCard(Workshop workshop) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Hero animation and navigation to workshop detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayWorkshopDetail(
                workshopId: workshop.pk,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workshop Image
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                  child: Image.network(
                    workshop.imageUrls[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              // Workshop Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workshop.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.coklat1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workshop.location,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.coklat2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Filtering workshops alphabetically
  List<Workshop> _filterWorkshopsAlphabetically(List<Workshop> workshops) {
    workshops.sort((a, b) => a.title.compareTo(b.title));
    return workshops;
  }

  Widget _WorkshopCard(Workshop workshop) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigasi ke detail workshop
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayWorkshopDetail(
                workshopId: workshop.pk,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workshop Image
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                  child: Image.network(
                    workshop.imageUrls.isNotEmpty
                        ? workshop.imageUrls[0]
                        : 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

              // Workshop Info
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFDCD2C2), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        workshop.location,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.coklat3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Workshop Title
                    Text(
                      workshop.title,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coklat1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Schedule
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          workshop.fields.openTime,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.coklat2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
