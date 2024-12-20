// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
    List<AddressElement> addresses;

    Address({
        required this.addresses,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        addresses: List<AddressElement>.from(json["addresses"].map((x) => AddressElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
    };
}

class AddressElement {
    int id;
    String title;
    String address;

    AddressElement({
        required this.id,
        required this.title,
        required this.address,
    });

    factory AddressElement.fromJson(Map<String, dynamic> json) => AddressElement(
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
