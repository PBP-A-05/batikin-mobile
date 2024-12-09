// To parse this JSON data, do
//
//     final removeFromCart = removeFromCartFromJson(jsonString);

import 'dart:convert';

RemoveFromCart removeFromCartFromJson(String str) => RemoveFromCart.fromJson(json.decode(str));

String removeFromCartToJson(RemoveFromCart data) => json.encode(data.toJson());

class RemoveFromCart {
    String status;
    String message;
    Data data;

    RemoveFromCart({
        required this.status,
        required this.message,
        required this.data,
    });

    factory RemoveFromCart.fromJson(Map<String, dynamic> json) => RemoveFromCart(
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
    int itemId;

    Data({
        required this.itemId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        itemId: json["item_id"],
    );

    Map<String, dynamic> toJson() => {
        "item_id": itemId,
    };
}