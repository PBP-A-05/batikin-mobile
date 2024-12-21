// To parse this JSON data, do
//
//     final orderHistory = orderHistoryFromJson(jsonString);

import 'dart:convert';

OrderHistory orderHistoryFromJson(String str) => OrderHistory.fromJson(json.decode(str));

String orderHistoryToJson(OrderHistory data) => json.encode(data.toJson());

class OrderHistory {
    String status;
    List<Order> orders;

    OrderHistory({
        required this.status,
        required this.orders,
    });

    factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        status: json["status"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
    };
}

class Order {
    int id;
    String totalPrice;
    DateTime createdAt;
    Address address;
    List<Item> items;

    Order({
        required this.id,
        required this.totalPrice,
        required this.createdAt,
        required this.address,
        required this.items,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        totalPrice: json["total_price"],
        createdAt: DateTime.parse(json["created_at"]),
        address: Address.fromJson(json["address"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "total_price": totalPrice,
        "created_at": createdAt.toIso8601String(),
        "address": address.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Address {
    int id;
    String title;
    String address;

    Address({
        required this.id,
        required this.title,
        required this.address,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        title: json["title"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "address": address,
    };
}

class Item {
    String productId;
    String productName;
    int quantity;
    String price;
    List<String> imageUrls;
    String category;

    Item({
        required this.productId,
        required this.productName,
        required this.quantity,
        required this.price,
        required this.imageUrls,
        required this.category,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["product_id"],
        productName: json["product_name"],
        quantity: json["quantity"],
        price: json["price"],
        imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "quantity": quantity,
        "price": price,
        "image_urls": List<dynamic>.from(imageUrls.map((x) => x)),
        "category": category,
    };
}
