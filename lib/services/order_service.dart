// lib/services/order_service.dart
import 'dart:convert';
import 'package:batikin_mobile/config/config.dart';
import 'package:batikin_mobile/models/order_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class OrderService {
  final CookieRequest request;

  OrderService(this.request);

  Future<List<Order>> fetchOrderHistory() async {
    final response = await request.get("${Config.baseUrl}/cart/api/get-order/");

    if (response != null) {
      final List<dynamic> orderList = response['orders'];
      return orderList.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
  }
}
