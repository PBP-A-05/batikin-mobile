// lib/services/product_service.dart
import 'package:http/http.dart' as http;
import 'package:batikin_mobile/models/product.dart';
import 'package:batikin_mobile/models/product_detail.dart';
import 'package:batikin_mobile/config/config.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/shopping/json/'),
    );
    if (response.statusCode == 200) {
      return productFromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ProductDetail> fetchProductDetail(String productId) async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/shopping/json/$productId/'),
    );
    if (response.statusCode == 200) {
      return productDetailFromJson(response.body).first;
    } else {
      throw Exception('Failed to load product detail');
    }
  }
}