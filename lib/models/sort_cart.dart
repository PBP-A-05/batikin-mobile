// To parse this JSON data, do
//
//     final sortCart = sortCartFromJson(jsonString);

import 'dart:convert';

SortCart sortCartFromJson(String str) => SortCart.fromJson(json.decode(str));

String sortCartToJson(SortCart data) => json.encode(data.toJson());

class SortCart {
    String status;
    Data data;

    SortCart({
        required this.status,
        required this.data,
    });

    factory SortCart.fromJson(Map<String, dynamic> json) => SortCart(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    List<CartItem> cartItems;
    String totalPrice;
    int totalQuantity;

    Data({
        required this.cartItems,
        required this.totalPrice,
        required this.totalQuantity,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        cartItems: List<CartItem>.from(json["cart_items"].map((x) => CartItem.fromJson(x))),
        totalPrice: json["total_price"],
        totalQuantity: json["total_quantity"],
    );

    Map<String, dynamic> toJson() => {
        "cart_items": List<dynamic>.from(cartItems.map((x) => x.toJson())),
        "total_price": totalPrice,
        "total_quantity": totalQuantity,
    };
}

class CartItem {
    int id;
    String productId;
    String productName;
    String price;
    int quantity;
    String itemTotal;
    List<String> imageUrls;
    String category;

    CartItem({
        required this.id,
        required this.productId,
        required this.productName,
        required this.price,
        required this.quantity,
        required this.itemTotal,
        required this.imageUrls,
        required this.category,
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        productId: json["product_id"],
        productName: json["product_name"],
        price: json["price"],
        quantity: json["quantity"],
        itemTotal: json["item_total"],
        imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "product_name": productName,
        "price": price,
        "quantity": quantity,
        "item_total": itemTotal,
        "image_urls": List<dynamic>.from(imageUrls.map((x) => x)),
        "category": category,
    };
}
