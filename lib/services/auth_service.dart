// lib/services/auth_service.dart

import 'dart:convert';
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

  Future<Map<String, dynamic>> logout() async {
    final String url = "${Config.baseUrl}/auth/logout/";
    final response = await request.logout(url);
    return response;
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
}
