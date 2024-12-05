// lib/models/product_model.dart
import 'dart:convert';

class Product {
  final String productId;
  final String productName;
  final double price;
  final String description;
  final List<String> imageUrls;
  final String category;

  Product({
    required this.productId,
    required this.productName,
    required this.price,
    required this.description,
    required this.imageUrls,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesFromJson = json['image_urls'] as List;
    List<String> imageUrls =
        imagesFromJson.map((url) => url as String).toList();

    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      price: double.parse(json['price']),
      description:
          json['description'] ?? '', // Assuming description is provided
      imageUrls: imageUrls,
      category: json['category'],
    );
  }
}
