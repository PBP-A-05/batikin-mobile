import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
//import 'package:batikin_mobile/constant/colors.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:provider/provider.dart';
//import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/models/workshop_detail_model.dart';

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

  Future<void> fetchWorkshopDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/workshops/json/${widget.workshopId}/'),
      );
      if (response.statusCode == 200) {
        final workshopDetail = workshopDetailFromJson(response.body);
        setState(() {
          workshop =
              workshopDetail.first; // Mengambil item pertama dari list API
          isLoading = false;
        });
      }
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
      appBar: AppBar(
        title: Text(workshop!.fields.title),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

                  // Workshop Description
                  Text(
                    workshop!.fields.description,
                    maxLines: isDescriptionExpanded ? 5 : null,
                    overflow: isDescriptionExpanded
                        ? TextOverflow.ellipsis
                        : TextOverflow.visible,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isDescriptionExpanded = !isDescriptionExpanded;
                      });
                    },
                    child: Text(
                      isDescriptionExpanded ? 'Read More' : 'Read Less',
                      style: const TextStyle(color: Colors.brown),
                    ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
