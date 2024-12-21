// lib/services/alamat_service.dart
import 'dart:convert';
import 'package:batikin_mobile/config/config.dart';
import 'package:batikin_mobile/models/profile_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AlamatService {
  static Future<bool> updateAddress(
      CookieRequest request, Address address) async {
    print('Updating address: ${address.id}');

    final response = await request.post(
      '${Config.baseUrl}/account/update_address/',
      {
        'id': address.id.toString(),
        'title': address.title,
        'address': address.address,
      },
    );
    print("Response: $response");
    if (response['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addAddress(CookieRequest request, Address address) async {
    final response = await request.post(
      '${Config.baseUrl}/account/add_address_flutter/',
      {
        'title': address.title,
        'address': address.address,
      },
    );
    print("Response: $response");
    if (response['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  }
}
