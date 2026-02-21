import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';
import '../widgets/alert_dialogs.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/rating_stars.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final l10n = AppLocalizations.of(context);
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    final wishlist = Provider.of<WishlistProvider>(context);
    final isWishlisted = wishlist.isWishlisted(product.id);
    final r = ResponsiveHelper(context);

    if (r.isDesktop) {
      return _buildDesktopLayout(
          context, product, l10n, locale, wishlist, isWishlisted, r);
    }
    return _buildMobileLayout(
        context, product, l10n, locale, wishlist, isWishlisted, r);
  }

  // ── Desktop: side-by-side image + info ─────────────────────────────

  Widget _buildDesktopLayout(
    BuildContext context,
    Product product,
    AppLocalizations l10n,
    LocaleProvider locale,
    WishlistProvider wishlist,
    bool isWishlisted,
    ResponsiveHelper r,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? AppColors.secondary : null,
            ),
            onPressed: () => wishlist.toggleWishlist(product),
          ),
          const CartIconBadge(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: r.maxContentWidth),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Left: product image ──
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppDimens.radiusLG),
                          child: Hero(
                            tag: 'product-${product.id}',
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              height: r.productImageHeight,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                    child:
                                        CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) =>
                                  Container(
                                color: Colors.grey.shade200,
                                child: Icon(
                                    Icons
                                        .image_not_supported_outlined,
                                    size: r.iconSize(60)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ── Right: product details ──
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                            8, 24, 40, 24),
                        child: _buildProductInfo(
                            context, product, l10n, locale, r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomBar(context, product, l10n, r),
        ],
      ),
    );
  }

  // ── Mobile: vertical SliverAppBar layout ───────────────────────────

  Widget _buildMobileLayout(
    BuildContext context,
    Product product,
    AppLocalizations l10n,
    LocaleProvider locale,
    WishlistProvider wishlist,
    bool isWishlisted,
    ResponsiveHelper r,
  ) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: r.productImageHeight,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'product-${product.id}',
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) =>
                            Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                              Icons.image_not_supported_outlined,
                              size: r.iconSize(60)),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isWishlisted
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            isWishlisted ? AppColors.secondary : null,
                      ),
                      onPressed: () =>
                          wishlist.toggleWishlist(product),
                    ),
                    const CartIconBadge(),
                  ],
                ),
                SliverToBoxAdapter(
                  child: r.constrainedContent(
                    child: Padding(
                      padding:
                          EdgeInsets.all(r.horizontalPadding),
                      child: _buildProductInfo(
                          context, product, l10n, locale, r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(context, product, l10n, r),
        ],
      ),
    );
  }

  // ── Shared product info column ─────────────────────────────────────

  Widget _buildProductInfo(
    BuildContext context,
    Product product,
    AppLocalizations l10n,
    LocaleProvider locale,
    ResponsiveHelper r,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category & Name
        Text(
          product.category,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: r.sp(13),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          product.name,
          style: TextStyle(
            fontSize: r.sp(24),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Rating
        RatingStars(
          rating: product.rating,
          reviewCount: product.reviewCount,
        ),
        const SizedBox(height: 16),

        // Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              locale.formatPrice(product.discountedPrice),
              style: TextStyle(
                fontSize: r.sp(28),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Description
        Text(
          l10n.t('description'),
          style: TextStyle(
            fontSize: r.sp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: TextStyle(
            fontSize: r.sp(14),
            color: Colors.grey.shade600,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),

        // Colors
        if (product.colors.isNotEmpty) ...[
          Text(
            l10n.t('colors'),
            style: TextStyle(
              fontSize: r.sp(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: product.colors.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedColor = color),
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                            .withValues(alpha: 0.1)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                        AppDimens.radiusSM),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    color,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primary
                          : null,
                      fontSize: r.sp(14),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Sizes
        if (product.sizes.isNotEmpty) ...[
          Text(
            l10n.t('sizes'),
            style: TextStyle(
              fontSize: r.sp(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: product.sizes.map((size) {
              final isSelected = _selectedSize == size;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedSize = size),
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                            .withValues(alpha: 0.1)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                        AppDimens.radiusSM),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primary
                          : null,
                      fontSize: r.sp(14),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Quantity
        Row(
          children: [
            Text(
              l10n.t('quantity'),
              style: TextStyle(
                fontSize: r.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    BorderRadius.circular(AppDimens.radiusSM),
                border: Border.all(
                    color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    child: Text(
                      '$_quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: r.sp(18),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () =>
                        setState(() => _quantity++),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Bottom action bar ──────────────────────────────────────────────

  Widget _buildBottomBar(
    BuildContext context,
    Product product,
    AppLocalizations l10n,
    ResponsiveHelper r,
  ) {
    return Container(
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: r.maxFormWidth),
            child: Row(
              children: [
                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (context, cart, _) {
                      final qty =
                          cart.getProductQuantity(product.id);
                      return SizedBox(
                        height: r.buttonHeight,
                        child: OutlinedButton(
                          onPressed: () {
                            cart.addToCart(
                              product,
                              color: _selectedColor,
                              size: _selectedSize,
                              quantity: _quantity,
                            );
                            AppAlertDialogs
                                .showAddedToCartSnackBar(context);
                          },
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Badge(
                                isLabelVisible: qty > 0,
                                label: Text(
                                  '$qty',
                                  style: TextStyle(
                                      fontSize: r.sp(10),
                                      color: Colors.white),
                                ),
                                backgroundColor:
                                    AppColors.secondary,
                                child: Icon(
                                    Icons
                                        .shopping_cart_outlined,
                                    size: r.iconSize(18)),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  qty > 0
                                      ? '${l10n.t('addToCart')} ($qty)'
                                      : l10n.t('addToCart'),
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: r.sp(12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: r.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        final cart = Provider.of<CartProvider>(
                            context,
                            listen: false);
                        cart.addToCart(
                          product,
                          color: _selectedColor,
                          size: _selectedSize,
                          quantity: _quantity,
                        );
                        Navigator.pushNamed(
                            context, AppRoutes.cart);
                      },
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flash_on,
                              size: r.iconSize(18)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l10n.t('buyNow'),
                              overflow:
                                  TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: r.sp(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
