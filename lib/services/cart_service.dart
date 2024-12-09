import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/config/config.dart';
import 'package:batikin_mobile/models/add_to_cart.dart';
import 'package:batikin_mobile/models/view_cart.dart';

class CartService {
  final CookieRequest request;

  CartService(this.request);

  Future<AddToCart> addToCart(String productId, int quantity) async {
    final response = await request.postJson(
      '${Config.baseUrl}/shopping/api/cart/add/$productId/',
      jsonEncode({
        'quantity': quantity,
      }),
    );
    return AddToCart.fromJson(response);
  }

  Future<ViewCart> viewCart() async {
    final response = await request.get(
      '${Config.baseUrl}/cart/api/view/',
    );
    return ViewCart.fromJson(response);
  }

  Future<ViewCart> sortCart(String sortBy) async {
    final response = await request.get(
      '${Config.baseUrl}/cart/api/sort/?sort_by=$sortBy',
    );
    return ViewCart.fromJson(response);
  }
}