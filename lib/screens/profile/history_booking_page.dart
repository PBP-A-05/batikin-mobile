// lib/screens/profile/history_booking_page.dart

import 'package:batikin_mobile/screens/profile/booking_detail_page.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/services/booking_service.dart';
import 'package:batikin_mobile/models/booking_model.dart';
import 'package:batikin_mobile/constants/colors.dart';

class HistoryBookingPage extends StatefulWidget {
  const HistoryBookingPage({Key? key}) : super(key: key);

  @override
  State<HistoryBookingPage> createState() => _HistoryBookingPageState();
}

class _HistoryBookingPageState extends State<HistoryBookingPage> {
  late Future<List<Booking>> _bookingFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    final bookingService = BookingService(request);
    _bookingFuture = bookingService.fetchBookingHistory();
  }

  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(booking.workshopTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal: ${booking.bookingDate}',
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Text('Waktu: ${booking.bookingTime}',
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Text('Lokasi: ${booking.location}',
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Text('Peserta: ${booking.participants} orang',
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _showNotAvailableFeature() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur ini belum tersedia'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Booking',
          style: TextStyle(
            color: AppColors.coklat2,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.coklat2,
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: AppColors.coklat2),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No bookings found.',
                  style: TextStyle(color: AppColors.coklat2)),
            );
          } else {
            final bookings = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF4ED),
                    border:
                        Border.all(color: AppColors.coklat1Rgba, width: 0.2),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0xFF4a412c),
                          image: DecorationImage(
                            image: NetworkImage(booking.imageUrls),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Details Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.workshopTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.coklat2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'untuk ${booking.participants} orang',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookingDetailPage(booking: booking),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Lihat Detail Booking',
                                    style: TextStyle(
                                      color: AppColors.coklat2,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    showToast(
                                      context,
                                      'Fitur belum tersedia',
                                      type: ToastType.success,
                                      gravity: ToastGravity.BOTTOM_RIGHT,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColors.coklat2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Ulas',
                                    style: TextStyle(
                                      color: AppColors.coklat2,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
