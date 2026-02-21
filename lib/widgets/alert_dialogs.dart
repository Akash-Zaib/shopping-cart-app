import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

class AppAlertDialogs {
  static void showAddedToCartSnackBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.t('addedToCart'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        ),
        action: SnackBarAction(
          label: l10n.t('viewCart'),
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<bool?> showRemoveFromCartDialog(
    BuildContext context,
    String productName,
  ) {
    final l10n = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            Flexible(child: Text(l10n.t('removeItemTitle'))),
          ],
        ),
        content: Text('${l10n.t('removeItemDesc')}\n\n"$productName"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.t('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.t('remove')),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showPlaceOrderDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        title: Row(
          children: [
            Icon(Icons.shopping_bag, color: AppColors.primary),
            const SizedBox(width: 8),
            Flexible(child: Text(l10n.t('confirmOrder'))),
          ],
        ),
        content: Text(l10n.t('confirmOrderDesc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.t('confirm')),
          ),
        ],
      ),
    );
  }
}
