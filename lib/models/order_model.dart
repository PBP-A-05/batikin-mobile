// lib/models/order_model.dart
import 'dart:convert';

class OrderResponse {
  List<Order> orders;
  String status;

  OrderResponse({required this.orders, required this.status});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var ordersList = json['orders'] as List;
    List<Order> orders =
        ordersList.map((order) => Order.fromJson(order)).toList();
    return OrderResponse(
      orders: orders,
      status: json['status'],
    );
  }
}

class Order {
  int orderId;
  double totalPrice;
  List<Item> items;
  DateTime createdAt;
  Address address;

  Order({
    required this.orderId,
    required this.totalPrice,
    required this.items,
    required this.createdAt,
    required this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<Item> items = itemsList.map((item) => Item.fromJson(item)).toList();

    return Order(
      orderId: json['order_id'],
      totalPrice: double.parse(json['total_price']),
      items: items,
      createdAt: DateTime.parse(json['created_at']),
      address: Address.fromJson(json['address']),
    );
  }
}

class Item {
  String productId;
  String productName;
  int quantity;
  double price;
  List<String> imageUrls;
  String category;

  Item({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.imageUrls,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    var imageUrlsFromJson = json['image_urls'] as List;
    List<String> imageUrls =
        imageUrlsFromJson.map((url) => url as String).toList();

    return Item(
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: double.parse(json['price']),
      imageUrls: imageUrls,
      category: json['category'],
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
