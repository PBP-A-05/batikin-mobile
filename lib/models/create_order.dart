// To parse this JSON data, do
//
//     final createOrder = createOrderFromJson(jsonString);

import 'dart:convert';

CreateOrder createOrderFromJson(String str) => CreateOrder.fromJson(json.decode(str));

String createOrderToJson(CreateOrder data) => json.encode(data.toJson());

class CreateOrder {
    String status;
    String message;
    Order order;

    CreateOrder({
        required this.status,
        required this.message,
        required this.order,
    });

    factory CreateOrder.fromJson(Map<String, dynamic> json) => CreateOrder(
        status: json["status"],
        message: json["message"],
        order: Order.fromJson(json["order"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "order": order.toJson(),
    };
}

class Order {
    int id;
    String totalPrice;
    Address address;

    Order({
        required this.id,
        required this.totalPrice,
        required this.address,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        totalPrice: json["total_price"],
        address: Address.fromJson(json["address"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "total_price": totalPrice,
        "address": address.toJson(),
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
