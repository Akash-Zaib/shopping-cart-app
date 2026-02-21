import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Electronics':
        return Icons.devices;
      case 'Fashion':
        return Icons.checkroom;
      case 'Home':
        return Icons.home_outlined;
      case 'Sports':
        return Icons.fitness_center;
      case 'Beauty':
        return Icons.spa_outlined;
      case 'Books':
        return Icons.menu_book_outlined;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveHelper(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: r.w(16), vertical: r.h(10)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusRound),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: r.iconSize(18),
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            SizedBox(width: r.w(6)),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: r.sp(13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
