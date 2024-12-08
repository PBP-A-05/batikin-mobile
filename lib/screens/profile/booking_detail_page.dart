// lib/screens/profile/booking_detail_page.dart

import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/booking_model.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailPage extends StatelessWidget {
  final Booking booking;

  const BookingDetailPage({Key? key, required this.booking}) : super(key: key);

  // Helper to format date and day name in Indonesian style
  String _formatDate(String dateStr) {
    // dateStr should be "YYYY-MM-DD"
    final parts = dateStr.split('-');
    final year = parts[0];
    final month = parts[1];
    final day = parts[2];
    return '$day-$month-$year'; // e.g. "20-12-2024"
  }

  String _dayName(String dateStr) {
    final date = DateTime.parse(dateStr);
    // Day names in Indonesian: Senin, Selasa, Rabu, Kamis, Jumat, Sabtu, Minggu
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(booking.bookingDate);
    final dayName = _dayName(booking.bookingDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Detail',
          style: TextStyle(
            color: AppColors.coklat2,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.coklat2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.coklat2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF4ED),
            border: Border.all(color: AppColors.coklat1Rgba, width: 0.2),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Workshop Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  booking.imageUrls,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),

              // Workshop Title
              Text(
                booking.workshopTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.coklat2,
                ),
              ),
              const SizedBox(height: 8),

              // Location Link
              GestureDetector(
                onTap: () async {
                  final url = booking.location;
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  'Link Google Maps',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[600],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date and Capacity Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TANGGAL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.coklat2,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateTime.parse(booking.bookingDate).day.toString(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.coklat2,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.coklat2,
                        ),
                      ),
                      Text(
                        dayName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.coklat2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jam: ${booking.bookingTime}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.coklat2,
                        ),
                      ),
                    ],
                  ),

                  // Capacity Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Kapasitas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.coklat2,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.participants.toString(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.coklat2,
                        ),
                      ),
                      const Text(
                        'Orang',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.coklat2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Close Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coklat1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
