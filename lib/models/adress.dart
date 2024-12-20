// To parse this JSON data, do
//
//     final adress = adressFromJson(jsonString);

import 'dart:convert';

Adress adressFromJson(String str) => Adress.fromJson(json.decode(str));

String adressToJson(Adress data) => json.encode(data.toJson());

class Adress {
    List<Address> addresses;

    Adress({
        required this.addresses,
    });

    factory Adress.fromJson(Map<String, dynamic> json) => Adress(
        addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
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
