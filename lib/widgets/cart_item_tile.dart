import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    final r = ResponsiveHelper(context);
    final imgSize = r.w(80).clamp(64.0, 110.0);

    return Dismissible(
      key: Key(item.product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: r.w(20)),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        child: Icon(Icons.delete_outline,
            color: Colors.white, size: r.iconSize(28)),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            title: const Text('Remove Item'),
            content: Text('Remove "${item.product.name}" from your cart?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Remove'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        cart.removeFromCart(item.product.id);
      },
      child: Container(
        padding: EdgeInsets.all(r.cardPadding * 0.75),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              child: CachedNetworkImage(
                imageUrl: item.product.imageUrl,
                width: imgSize,
                height: imgSize,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: imgSize,
                  height: imgSize,
                  color: Colors.grey.shade200,
                ),
                errorWidget: (context, url, error) => Container(
                  width: imgSize,
                  height: imgSize,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
            SizedBox(width: r.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: r.sp(14),
                    ),
                  ),
                  SizedBox(height: r.h(4)),
                  if (item.selectedColor != null ||
                      item.selectedSize != null)
                    Text(
                      [
                        if (item.selectedColor != null) item.selectedColor!,
                        if (item.selectedSize != null) item.selectedSize!,
                      ].join(' • '),
                      style: TextStyle(
                        fontSize: r.sp(12),
                        color: Colors.grey.shade500,
                      ),
                    ),
                  SizedBox(height: r.h(6)),
                  Text(
                    locale.formatPrice(item.product.discountedPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: r.sp(15),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: r.iconSize(18)),
                    onPressed: () =>
                        cart.decrementQuantity(item.product.id),
                    constraints: BoxConstraints(
                        minWidth: r.w(36), minHeight: r.h(36)),
                    padding: EdgeInsets.zero,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: r.w(4)),
                    child: Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: r.sp(16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: r.iconSize(18)),
                    onPressed: () =>
                        cart.incrementQuantity(item.product.id),
                    constraints: BoxConstraints(
                        minWidth: r.w(36), minHeight: r.h(36)),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
