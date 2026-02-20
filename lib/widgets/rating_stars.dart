import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final int? reviewCount;
  final bool showText;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.reviewCount,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(Icons.star, color: AppColors.star, size: size);
          } else if (index < rating) {
            return Icon(Icons.star_half, color: AppColors.star, size: size);
          } else {
            return Icon(Icons.star_border, color: AppColors.star, size: size);
          }
        }),
        if (showText) ...[
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: size * 0.75,
            ),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 4),
            Text(
              '($reviewCount)',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: size * 0.7,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
