// lib/services/booking_service.dart
import 'package:batikin_mobile/config/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/models/booking_model.dart';

class BookingService {
  final CookieRequest request;

  BookingService(this.request);

  Future<List<Booking>> fetchBookingHistory() async {
    final response =
        await request.get("${Config.baseUrl}/booking/api/get-bookings/");

    if (response['status'] == 'success' && response['bookings'] != null) {
      final List bookingsJson = response['bookings'];
      return bookingsJson.map((json) => Booking.fromJson(json)).toList();
    }

    return [];
  }
}
