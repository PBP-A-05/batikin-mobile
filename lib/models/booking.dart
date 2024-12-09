import 'dart:convert';

List<Booking> bookingFromJson(String str) =>
    List<Booking>.from(json.decode(str).map((x) => Booking.fromJson(x)));

String bookingToJson(List<Booking> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Booking {
  String model;
  String pk;
  Fields fields;

  Booking({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String workshopId;
  String userId;
  String bookingDate;
  String bookingTime;
  int participants;

  Fields({
    required this.workshopId,
    required this.userId,
    required this.bookingDate,
    required this.bookingTime,
    required this.participants,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        workshopId: json["workshop_id"],
        userId: json["user_id"],
        bookingDate: json["booking_date"],
        bookingTime: json["booking_time"],
        participants: json["participants"],
      );

  Map<String, dynamic> toJson() => {
        "workshop_id": workshopId,
        "user_id": userId,
        "booking_date": bookingDate,
        "booking_time": bookingTime,
        "participants": participants,
      };
}
