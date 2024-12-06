// To parse this JSON data, do
//
//     final productDetail = productDetailFromJson(jsonString);

import 'dart:convert';

List<ProductDetail> productDetailFromJson(String str) => List<ProductDetail>.from(json.decode(str).map((x) => ProductDetail.fromJson(x)));

String productDetailToJson(List<ProductDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductDetail {
    String model;
    String pk;
    Fields fields;

    ProductDetail({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
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
    String storeUrl;
    String storeAddress;
    String productName;
    String price;
    List<String> imageUrls;
    String additionalInfo;
    String productLink;
    String category;

    Fields({
        required this.storeUrl,
        required this.storeAddress,
        required this.productName,
        required this.price,
        required this.imageUrls,
        required this.additionalInfo,
        required this.productLink,
        required this.category,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        storeUrl: json["store_url"],
        storeAddress: json["store_address"],
        productName: json["product_name"],
        price: json["price"],
        imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
        additionalInfo: json["additional_info"],
        productLink: json["product_link"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "store_url": storeUrl,
        "store_address": storeAddress,
        "product_name": productName,
        "price": price,
        "image_urls": List<dynamic>.from(imageUrls.map((x) => x)),
        "additional_info": additionalInfo,
        "product_link": productLink,
        "category": category,
    };
}
