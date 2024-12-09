import 'dart:convert';

List<Workshop> workshopFromJson(String str) =>
    List<Workshop>.from(json.decode(str).map((x) => Workshop.fromJson(x)));

String workshopToJson(List<Workshop> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Workshop {
  String model;
  String pk;
  Fields fields;

  Workshop({
    required this.model,
    required this.pk,
    required this.fields,
  });

  // Getter untuk properti dari fields
  String get title => fields.title;
  String get location => fields.location;
  List<String> get imageUrls => fields.imageUrls;

  factory Workshop.fromJson(Map<String, dynamic> json) => Workshop(
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
  String title;
  String location;
  String description;
  String openTime;
  String schedule;
  List<String> imageUrls;
  String website;

  Fields({
    required this.title,
    required this.location,
    required this.description,
    required this.openTime,
    required this.schedule,
    required this.imageUrls,
    required this.website,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        location: json["location"],
        description: json["description"],
        openTime: json["open_time"],
        schedule: json["schedule"],
        imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "location": location,
        "description": description,
        "open_time": openTime,
        "schedule": schedule,
        "image_urls": List<dynamic>.from(imageUrls.map((x) => x)),
        "website": website,
      };
}
