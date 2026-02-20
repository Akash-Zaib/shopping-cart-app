import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/wishlist_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/product_card.dart';
import '../widgets/responsive_layout.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wishlist = Provider.of<WishlistProvider>(context);
    final crossAxisCount = ResponsiveLayout.getGridCrossAxisCount(context);
    final aspectRatio = ResponsiveLayout.getGridChildAspectRatio(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.t('wishlist')} (${wishlist.itemCount})'),
        actions: [
          if (wishlist.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    title: const Text('Clear Wishlist'),
                    content: const Text('Remove all items from your wishlist?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l10n.t('cancel')),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(l10n.t('remove')),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  wishlist.clearWishlist();
                }
              },
            ),
        ],
      ),
      body: wishlist.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 100,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.t('emptyWishlist'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.t('emptyWishlistDesc'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      ),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: Text(l10n.t('browseProducts')),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: wishlist.items.length,
              itemBuilder: (context, index) {
                final product = wishlist.items[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productDetail,
                      arguments: product,
                    );
                  },
                );
              },
            ),
    );
  }
}
