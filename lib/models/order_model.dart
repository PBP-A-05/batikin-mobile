// lib/models/order_model.dart
import 'dart:convert';

class OrderResponse {
  List<Order> orders;
  String status;

  OrderResponse({required this.orders, required this.status});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var ordersList = json['orders'] as List? ?? [];
    List<Order> orders =
        ordersList.map((order) => Order.fromJson(order)).toList();
    return OrderResponse(
      orders: orders,
      status: json['status'] ?? 'Unknown',
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
    var itemsList = json['items'] as List? ?? [];
    List<Item> items = itemsList.map((item) => Item.fromJson(item)).toList();

    return Order(
      orderId: json['order_id'] ?? 0,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      items: items,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : Address(id: 0, title: 'Unknown', address: 'Unknown'),
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
    var imageUrlsFromJson = json['image_urls'] as List? ?? [];
    List<String> imageUrls =
        imageUrlsFromJson.map((url) => url as String? ?? 'Unknown').toList();

    return Item(
      productId: json['product_id'] ?? 'Unknown',
      productName: json['product_name'] ?? 'Unknown',
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrls: imageUrls.isNotEmpty
          ? imageUrls
          : ['https://via.placeholder.com/100'],
      category:
          json['category']?.toString().replaceAll('_', ' ').toUpperCase() ??
              'Unknown',
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
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      address: json['address'] ?? 'Unknown',
    );
  }
}
