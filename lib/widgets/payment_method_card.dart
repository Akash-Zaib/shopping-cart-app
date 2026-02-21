import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class PaymentMethodCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveHelper(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: r.w(16), vertical: r.h(14)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(r.w(8)),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: r.iconSize(24),
              ),
            ),
            SizedBox(width: r.w(14)),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: r.sp(14),
                  color: isSelected
                      ? AppColors.primary
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle,
                  color: AppColors.primary, size: r.iconSize(22)),
          ],
        ),
      ),
    );
  }
}
