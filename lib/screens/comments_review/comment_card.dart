import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/comment_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:batikin_mobile/utils/utils_function.dart';

class CommentCard extends StatelessWidget {
  final Review review;

  const CommentCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.coklat1.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.coklat1.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.coklat1.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: AppColors.coklat1,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.fields.user,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.coklat1,
                        ),
                      ),
                      Text(
                        formatDate(review.fields.createdAt),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.coklat2.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.coklat1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.coklat2,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${review.fields.rating}/5',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coklat2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.fields.review,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.coklat2,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
