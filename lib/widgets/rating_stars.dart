import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

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
    final r = ResponsiveHelper(context);
    final scaledSize = r.iconSize(size);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(Icons.star, color: AppColors.star, size: scaledSize);
          } else if (index < rating) {
            return Icon(Icons.star_half, color: AppColors.star, size: scaledSize);
          } else {
            return Icon(Icons.star_border, color: AppColors.star, size: scaledSize);
          }
        }),
        if (showText) ...[
          SizedBox(width: r.w(6)),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: r.sp(size * 0.75),
            ),
          ),
          if (reviewCount != null) ...[
            SizedBox(width: r.w(4)),
            Text(
              '($reviewCount)',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: r.sp(size * 0.7),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
