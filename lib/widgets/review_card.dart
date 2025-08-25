import 'package:flutter/material.dart';
import 'package:restaurant_flutter/model/customer_review.dart';

class ReviewCard extends StatelessWidget {
  final CustomerReview review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris untuk Nama dan Tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.name,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                review.date,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Teks
          Text(
            '"${review.review}"',
            style: textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
