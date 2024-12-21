// lib/services/auth_service.dart

import 'dart:convert';
import 'package:batikin_mobile/models/profile_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/config/config.dart';

class AuthService {
  final CookieRequest request;

  AuthService(this.request);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final String url = "${Config.baseUrl}/auth/login/";
    final response = await request.login(url, {
      'username': username,
      'password': password,
    });
    return response;
  }

  Future logout() async {
    final String url = "${Config.baseUrl}/auth/logout/";
    final response = await request.logout(url);
    if (response['status'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password1,
    required String password2,
  }) async {
    final String url = "${Config.baseUrl}/auth/register/";
    final response = await request.postJson(
        url,
        jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "username": username,
          "password1": password1,
          "password2": password2,
        }));
    return response;
  }

  Future<Profile?> getUserInfo() async {
    final response =
        await request.get("${Config.baseUrl}/account/get_user_info");
    if (response != null && response.isNotEmpty) {
      try {
        return Profile.fromJson(response);
      } catch (e) {
        // Handle JSON parsing error
        print("Error parsing profile data: $e");
        return null;
      }
    } else {
      // Handle empty response or unauthorized access
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final String url = "${Config.baseUrl}/account/update_profile/";
    final response = await request.post(
      url,
      {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
      },
    );
    return response;
  }
}
