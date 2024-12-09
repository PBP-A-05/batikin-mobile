// To parse this JSON data, do
//
//     final updateCart = updateCartFromJson(jsonString);

import 'dart:convert';

UpdateCart updateCartFromJson(String str) => UpdateCart.fromJson(json.decode(str));

String updateCartToJson(UpdateCart data) => json.encode(data.toJson());

class UpdateCart {
    String status;
    String message;
    Data data;

    UpdateCart({
        required this.status,
        required this.message,
        required this.data,
    });

    factory UpdateCart.fromJson(Map<String, dynamic> json) => UpdateCart(
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
    int quantity;
    String price;
    String itemTotal;

    Data({
        required this.itemId,
        required this.quantity,
        required this.price,
        required this.itemTotal,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        itemId: json["item_id"],
        quantity: json["quantity"],
        price: json["price"],
        itemTotal: json["item_total"],
    );

    Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "quantity": quantity,
        "price": price,
        "item_total": itemTotal,
    };
}
