import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/comment_model.dart'; // Ensure this import is correct
import 'package:google_fonts/google_fonts.dart';

class CommentCard extends StatelessWidget {
  final Review review;

  const CommentCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User and Rating Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Info
                Text(
                  'User ${review.fields.user}', // Replace with actual user name if available
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                // Star Rating
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.fields.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Review Text
            Text(
              review.fields.review,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Date
            Text(
              'Posted on: ${review.fields.createdAt.toLocal().toString().split(' ')[0]}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
