// lib/models/profile_model.dart
import 'dart:convert';

class Profile {
  String firstName;
  String lastName;
  String phoneNumber;
  String username;
  List<Address> addresses;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.username,
    required this.addresses,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    var addressList = json['addresses'] as List;
    List<Address> addressObjs =
        addressList.map((address) => Address.fromJson(address)).toList();

    return Profile(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      username: json['username'],
      addresses: addressObjs,
    );
  }
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      title: json['title'],
      address: json['address'],
    );
  }
}
