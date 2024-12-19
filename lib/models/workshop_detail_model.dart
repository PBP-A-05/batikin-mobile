import 'dart:convert';

class WorkshopDetail {
  final String id;
  final WorkshopFields fields;

  WorkshopDetail({
    required this.id,
    required this.fields,
  });

  factory WorkshopDetail.fromJson(Map<String, dynamic> json) {
    return WorkshopDetail(
      id: json['id'],
      fields: WorkshopFields.fromJson(json['fields']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fields': fields.toJson(),
    };
  }
}

class WorkshopFields {
  final String title;
  final String location;
  final String description;
  final String openTime;
  final List<String> imageUrls;
  final String website;

  WorkshopFields({
    required this.title,
    required this.location,
    required this.description,
    required this.openTime,
    required this.imageUrls,
    required this.website,
  });

  factory WorkshopFields.fromJson(Map<String, dynamic> json) {
    return WorkshopFields(
      title: json['title'],
      location: json['location'],
      description: json['description'],
      openTime: json['open_time'],
      imageUrls: List<String>.from(json['image_urls']),
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'description': description,
      'open_time': openTime,
      'image_urls': imageUrls,
      'website': website,
    };
  }
}

// Fungsi untuk parsing JSON menjadi daftar WorkshopDetail
List<WorkshopDetail> workshopDetailFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str);
  return jsonData.map((e) => WorkshopDetail.fromJson(e)).toList();
}

// Fungsi untuk mengonversi daftar WorkshopDetail menjadi JSON
String workshopDetailToJson(List<WorkshopDetail> data) {
  final List<Map<String, dynamic>> jsonData =
      data.map((e) => e.toJson()).toList();
  return json.encode(jsonData);
}
