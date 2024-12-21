import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:batikin_mobile/models/comment_model.dart';
import 'package:batikin_mobile/utils/utils_function.dart';
import 'package:batikin_mobile/config/config.dart';

class CommentService {
  Future<List<Review>> fetchReviews(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/review/get-reviews/$productId/'),
      );
      
      if (response.statusCode == 200) {
        return reviewFromJson(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  Future<bool> createReview({
    required String productId,
    required int rating,
    required String review,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/review/create/'),
        headers: await getHeaders(),
        body: jsonEncode({
          'product_id': productId,
          'rating': rating,
          'review': review,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error creating review: $e');
      return false;
    }
  }
}
