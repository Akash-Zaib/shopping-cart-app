import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'alert_dialogs.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    final isWishlisted = wishlist.isWishlisted(product.id);
    final r = ResponsiveHelper(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                            Icons.image_not_supported_outlined,
                            size: r.iconSize(40)),
                      ),
                    ),
                  ),
                  if (product.discount > 0)
                    Positioned(
                      top: r.w(8),
                      left: r.w(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: r.w(8), vertical: r.h(4)),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusSM),
                        ),
                        child: Text(
                          '-${product.discount.toInt()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: r.sp(11),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: r.w(8),
                    right: r.w(8),
                    child: GestureDetector(
                      onTap: () {
                        wishlist.toggleWishlist(product);
                        final l10n = AppLocalizations.of(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isWishlisted
                                  ? l10n.t('removedFromWishlist')
                                  : l10n.t('addedToWishlist'),
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(r.w(6)),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .cardColor
                              .withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isWishlisted
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                          size: r.iconSize(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: r.w(8), vertical: r.h(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: r.sp(13),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star,
                            color: AppColors.star,
                            size: r.iconSize(14)),
                        SizedBox(width: r.w(2)),
                        Text(
                          '${product.rating}',
                          style: TextStyle(
                              fontSize: r.sp(11),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          ' (${product.reviewCount})',
                          style: TextStyle(
                              fontSize: r.sp(11),
                              color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            locale.formatPrice(
                                product.discountedPrice),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: r.sp(14),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ),
                        Consumer<CartProvider>(
                          builder: (context, cart, _) {
                            final qty =
                                cart.getProductQuantity(product.id);
                            return GestureDetector(
                              onTap: () {
                                cart.addToCart(product);
                                AppAlertDialogs
                                    .showAddedToCartSnackBar(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(r.w(8)),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.radiusSM),
                                ),
                                child: Badge(
                                  isLabelVisible: qty > 0,
                                  label: Text(
                                    '$qty',
                                    style: TextStyle(
                                        fontSize: r.sp(8),
                                        color: Colors.white),
                                  ),
                                  backgroundColor:
                                      AppColors.secondary,
                                  offset: const Offset(8, -8),
                                  child: Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                    size: r.iconSize(16),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
