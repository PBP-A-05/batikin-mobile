import 'package:batikin_mobile/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:provider/provider.dart';
//import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/models/workshop_detail_model.dart';
import 'package:batikin_mobile/screens/booking/make_a_booking.dart';

class DisplayWorkshopDetail extends StatefulWidget {
  final String workshopId;

  const DisplayWorkshopDetail({super.key, required this.workshopId});

  @override
  State<DisplayWorkshopDetail> createState() => _DisplayWorkshopDetailState();
}

class _DisplayWorkshopDetailState extends State<DisplayWorkshopDetail> {
  WorkshopDetail? workshop;
  bool isLoading = true;
  bool isDescriptionExpanded = true;
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchWorkshopDetail();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //MASIH DATA DUMMY AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  Future<void> fetchWorkshopDetail() async {
    try {
      final dummyWorkshopDetail = [
        WorkshopDetail(
          fields: WorkshopFields(
            title: "Workshop Flutter",
            location: "Jakarta, Indonesia",
            description: "Belajar Flutter bersama para expert di bidangnya.",
            openTime: "09:00 AM - 05:00 PM", //ada workshop yang ga ada waktu
            website: "https://flutter.dev",
            imageUrls: [
              "https://via.placeholder.com/400x300",
              "https://via.placeholder.com/400x300",
              "https://via.placeholder.com/400x300",
            ],
          ),
          id: '',
        ),
      ];

      setState(() {
        workshop =
            dummyWorkshopDetail.first; // Mengambil item pertama dari data dummy
        isLoading = false;
      });

      // Jika API tersedia, maka bisa mengganti bagian di atas dengan kode API
      /*
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/workshops/json/${widget.workshopId}/'),
    );
    if (response.statusCode == 200) {
      final workshopDetail = workshopDetailFromJson(response.body);
      setState(() {
        workshop = workshopDetail.first;
        isLoading = false;
      });
    }
    */
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (workshop == null) {
      return const Center(
        child: Text('Workshop not found.'),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carousel for Workshop Images
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: workshop!.fields.imageUrls.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        workshop!.fields.imageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
                // Dots Indicator
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      workshop!.fields.imageUrls.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentImageIndex == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? Colors.brown
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Workshop Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Workshop Title
                      Text(
                        workshop!.fields.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.coklat2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Workshop Location
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            workshop!.fields.location,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Open Time
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Open Time: ${workshop!.fields.openTime}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Website Link
                      Row(
                        children: [
                          const Icon(Icons.link, size: 16),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              //launchUrl(Uri.parse(workshop!.fields.website));
                            },
                            child: const Text(
                              'Visit Website',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Separator Line
                      Container(
                        height: 1, // Tinggi garis
                        margin: const EdgeInsets.symmetric(
                            vertical: 8), // Jarak atas dan bawah
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Warna dasar garis
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200, // Warna bayangan
                              offset: const Offset(0,
                                  1), // Posisi bayangan (horizontal, vertikal)
                              blurRadius: 4, // Jarak blur
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Workshop Description
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16), // Jarak antar elemen
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title: "Deskripsi Workshop"
                            Text(
                              "Deskripsi Workshop",
                              style: TextStyle(
                                fontSize: 18, // Ukuran font lebih besar
                                fontWeight: FontWeight.w600, // Semi-bold
                                color: Colors.brown, // Warna coklat
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Workshop Description
                            Text(
                              workshop!.fields.description,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Header Transparan
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Workshop Details',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MakeABookingPage(), // Ganti dengan nama class di make_a_booking.dart
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Make a Booking!",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
