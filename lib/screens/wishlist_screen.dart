import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/wishlist_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wishlist = Provider.of<WishlistProvider>(context);
    final r = ResponsiveHelper(context);
    final crossAxisCount = r.gridCrossAxisCount;
    final aspectRatio = r.gridChildAspectRatio;

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
                    content:
                        const Text('Remove all items from your wishlist?'),
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
                padding: EdgeInsets.all(r.horizontalPadding * 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: r.iconSize(100),
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: r.h(24)),
                    Text(
                      l10n.t('emptyWishlist'),
                      style: TextStyle(
                        fontSize: r.sp(22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.h(8)),
                    Text(
                      l10n.t('emptyWishlistDesc'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: r.sp(15),
                      ),
                    ),
                    SizedBox(height: r.h(32)),
                    SizedBox(
                      height: r.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined,
                                size: r.iconSize(18)),
                            SizedBox(width: r.w(8)),
                            Flexible(
                              child: Text(l10n.t('browseProducts'),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: r.sp(14))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(r.horizontalPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: r.w(12),
                mainAxisSpacing: r.w(12),
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
