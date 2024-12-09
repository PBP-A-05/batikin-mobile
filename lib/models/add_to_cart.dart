// To parse this JSON data, do
//
//     final addToCart = addToCartFromJson(jsonString);

import 'dart:convert';

AddToCart addToCartFromJson(String str) => AddToCart.fromJson(json.decode(str));

String addToCartToJson(AddToCart data) => json.encode(data.toJson());

class AddToCart {
    String status;
    String message;
    Data data;

    AddToCart({
        required this.status,
        required this.message,
        required this.data,
    });

    factory AddToCart.fromJson(Map<String, dynamic> json) => AddToCart(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int cartItemId;
    String productId;
    String productName;
    int quantity;
    String price;

    Data({
        required this.cartItemId,
        required this.productId,
        required this.productName,
        required this.quantity,
        required this.price,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        cartItemId: json["cart_item_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        quantity: json["quantity"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "cart_item_id": cartItemId,
        "product_id": productId,
        "product_name": productName,
        "quantity": quantity,
        "price": price,
    };
}
