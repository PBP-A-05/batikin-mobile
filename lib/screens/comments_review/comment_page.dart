import 'package:flutter/material.dart';
import 'package:batikin_mobile/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/constant/colors.dart';
import 'package:batikin_mobile/widgets/custom_text_field.dart';
import 'package:batikin_mobile/widgets/custom_button.dart'; // Import CustomButton
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class CommentPage extends StatefulWidget {
  final String productId;
  final String productName;

  const CommentPage({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;

  Future<List<dynamic>> fetchReviews() async {
  final request = context.read<CookieRequest>();
  try {
    
    final response = await request.get(
      'http://127.0.0.1:8000/review/json/${widget.productId}/',
    );
    
    if (response == null) {
      print('Response is null');
      return [];
    }

    // If response is a List, process each review
    if (response is List) {
      return response.map((review) {
        return {
          'rating': review['fields']['rating'],
          'comment': review['fields']['review']
        };
      }).toList();
    }

      return [];
    } catch (e, stackTrace) {
      print('Error in fetchReviews: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<void> submitComment() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      final request = context.read<CookieRequest>();
      try {
        final response = await request.postJson(
          'http://127.0.0.1:8000/review/review/create/',
          jsonEncode(<String, String> {
            'product_id': widget.productId,
            'rating': _rating.toString(),
            'review': _commentController.text,
          }),
        );

        if (response['status'] == 'success' && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Review berhasil dikirim!',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: AppColors.coklat2,
            ),
          );

          await fetchReviews();

          _commentController.clear();
          setState(() {
            _rating = 0;
          });

          Navigator.pop(context);
        } else {
          print('Failed to submit review: ${response['message']}');
        }
      } catch (e) {
        print('Error submitting review: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal mengirim review. Silakan coba lagi.',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            slivers: [
              // Spacing for AppBar
              const SliverToBoxAdapter(
                child: SizedBox(height: kToolbarHeight + 32),
              ),

              // Existing Reviews
              SliverToBoxAdapter(
                child: FutureBuilder<List<dynamic>>(
                  future: fetchReviews(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading reviews',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    }

                    final comments = snapshot.data ?? [];
                    
                    return Column(
                      children: comments.map<Widget>((comment) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.coklat1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ...List.generate(
                                    5,
                                    (index) => Icon(
                                      index < (comment['rating'] ?? 0) 
                                          ? Icons.star 
                                          : Icons.star_border,
                                      color: AppColors.coklat2,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                comment['comment'] ?? '',
                                style: GoogleFonts.poppins(),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              // New Review Form
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Beri Rating',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coklat1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Star Rating
                          Row(
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rating = index + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    index < _rating ? Icons.star : Icons.star_border,
                                    color: AppColors.coklat2,
                                    size: 32,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),

                          Text(
                            'Tulis Review',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coklat1,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Review TextField
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.coklat1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: _commentController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Bagikan pengalaman belanja Anda...',
                                hintStyle: GoogleFonts.poppins(
                                  color: AppColors.coklat2.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mohon tulis review Anda';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Fixed AppBar
          _buildAppBar(),

          // Submit Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildSubmitButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.coklat1.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.coklat1),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Tulis Review',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coklat1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // For balance
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppColors.bgGradientCoklat,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: submitComment,
        child: Text(
          'Kirim Review',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
