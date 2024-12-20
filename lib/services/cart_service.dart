import 'dart:convert';
import 'package:batikin_mobile/models/address.dart';
import 'package:batikin_mobile/models/create_order.dart' as order_models;
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

  Future<Address> getAddresses() async {
    final response = await request.get('${Config.baseUrl}/account/get_addresses/');
    return Address.fromJson(response);
  }

  Future<order_models.CreateOrder> createOrder(int addressId, List<Map<String, dynamic>> items) async {
    final response = await request.postJson(
      '${Config.baseUrl}/cart/api/create_order/',
      jsonEncode({
        'address_id': addressId,
        'items': items,
      }),
    );
    return order_models.CreateOrder.fromJson(response);
  }

  Future<Map<String, dynamic>> updateCartItem(int itemId, int quantity) async {
    final response = await request.post(
      '${Config.baseUrl}/cart/api/update/$itemId/',
      {
        'quantity': quantity.toString(),
      },
    );
    return response;
  }

  Future<Map<String, dynamic>> removeCartItem(int itemId) async {
    final response = await request.post(
      '${Config.baseUrl}/cart/api/remove/$itemId/',
      {},
    );
    return response;
  }
}