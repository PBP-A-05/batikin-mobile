// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String model;
    String pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
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
    String user;
    String product;
    ProfilePic profilePic;
    int rating;
    String review;
    DateTime createdAt;
    DateTime updatedAt;

    Fields({
        required this.user,
        required this.product,
        required this.profilePic,
        required this.rating,
        required this.review,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        product: json["product"],
        profilePic: ProfilePic.fromJson(json["profile_pic"]),
        rating: json["rating"],
        review: json["review"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "product": product,
        "profile_pic": profilePic.toJson(),
        "rating": rating,
        "review": review,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class ProfilePic {
    ProfilePic();

    factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
    );

    Map<String, dynamic> toJson() => {
    };
}

class Comment {
  final String id;
  final String userId;
  final String productId;
  final double rating;
  final String review;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['pk'],
      userId: json['fields']['user'],
      productId: json['fields']['product'],
      rating: json['fields']['rating'].toDouble(),
      review: json['fields']['review'],
      createdAt: DateTime.parse(json['fields']['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'product': productId,
      'rating': rating,
      'review': review,
      'created_at': createdAt.toIso8601String(),
    };
  }
}