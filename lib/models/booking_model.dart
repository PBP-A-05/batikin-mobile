// lib/models/booking_model.dart

class Booking {
  final String workshopTitle;
  final String location;
  final String bookingDate;
  final String bookingTime;
  final int participants;
  final String imageUrls;
  final String workshopId;

  Booking({
    required this.workshopTitle,
    required this.location,
    required this.bookingDate,
    required this.bookingTime,
    required this.participants,
    required this.imageUrls,
    required this.workshopId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      workshopTitle: json['workshop_title'] as String,
      location: json['location'] as String,
      bookingDate: json['booking_date'] as String,
      bookingTime: json['booking_time'] as String,
      participants: json['participants'] as int,
      imageUrls: json['image_urls'] as String,
      workshopId: json['workshop_id'] as String,
    );
  }
}
