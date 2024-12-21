// lib/services/order_service.dart
import 'dart:convert';
import 'package:batikin_mobile/config/config.dart';
import 'package:batikin_mobile/models/order_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class OrderService {
  final CookieRequest request;

  OrderService(this.request);

  Future<List<Order>> fetchOrderHistory() async {
    try {
      final response =
          await request.get("${Config.baseUrl}/cart/api/get-order/");
      if (response != null && response['orders'] != null) {
        // Ensure 'orders' is a List
        if (response['orders'] is List) {
          final List<dynamic> orderList = response['orders'];
          return orderList.map((json) {
            if (json is Map<String, dynamic>) {
              return Order.fromJson(json);
            } else {
              throw Exception('Invalid order data format');
            }
          }).toList();
        } else {
          throw Exception("'orders' is not a List in the response");
        }
      } else if (response != null && response['error'] != null) {
        // Handle specific error messages from backend
        throw Exception('Error: ${response['error']}');
      } else {
        throw Exception('Unexpected response structure');
      }
    } catch (e) {
      print('Error in fetchOrderHistory: $e');
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
