import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:batikin_mobile/screens/shopping/display_product_detail.dart';
import 'package:batikin_mobile/models/comment_model.dart';
import 'package:batikin_mobile/config/config.dart';

class CommentEditPage extends StatefulWidget {
  final String productId;
  final String productName;
  final Review review;

  const CommentEditPage({
    Key? key,
    required this.productId,
    required this.productName,
    required this.review,
  }) : super(key: key);

  @override
  _CommentEditPageState createState() => _CommentEditPageState();
}

class _CommentEditPageState extends State<CommentEditPage> {
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with existing review data
    _commentController.text = widget.review.fields.review;
    _rating = widget.review.fields.rating.toDouble();
  }

  Future<void> updateComment() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      final request = context.read<CookieRequest>();
      try {
        final response = await request.postJson(
          '${Config.baseUrl}/review/edit/${widget.review.pk}/${widget.productId}/',
          jsonEncode({
            'rating': _rating.toString(),
            'review': _commentController.text,
          }),
        );

        if (response['status'] == 'success' && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Review berhasil diperbarui!',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: AppColors.coklat2,
            ),
          );

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayProductDetail(
                  productId: widget.productId,
                ),
              ),
            );
          }
        }
      } catch (e) {
        print('Error updating review: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal memperbarui review. Silakan coba lagi.',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> deleteReview() async {
    // Show confirmation dialog first
    final bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hapus Review',
            style: GoogleFonts.poppins(
              color: AppColors.coklat1,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus review ini?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: AppColors.coklat1),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final request = context.read<CookieRequest>();
      try {
        final response = await request.postJson(
          '${Config.baseUrl}/review/reviews/delete/${widget.review.pk}/',
          jsonEncode({}),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Review berhasil dihapus!',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: AppColors.coklat2,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayProductDetail(
                productId: widget.productId,
              ),
            ),
          );
        }
      } catch (e) {
        print('Error deleting review: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal menghapus review. Silakan coba lagi.',
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
      appBar: AppBar(
        title: Text(
          'Edit Review',
          style: GoogleFonts.poppins(
            color: AppColors.coklat1,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.coklat1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.productName,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coklat1,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Rating',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.coklat1,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: AppColors.coklat2,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Text(
                'Review',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.coklat1,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tulis review Anda di sini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.coklat1.withOpacity(0.25)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.coklat1.withOpacity(0.25)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.coklat1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Review tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: deleteReview,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete),
                    const SizedBox(width: 8),
                    Text(
                      'Hapus Review',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coklat1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Perbarui Review',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
