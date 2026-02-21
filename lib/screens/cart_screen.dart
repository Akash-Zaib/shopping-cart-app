import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = Provider.of<CartProvider>(context);
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    final r = ResponsiveHelper(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.t('cart')} (${cart.itemCount})'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    title: const Text('Clear Cart'),
                    content: const Text('Remove all items from your cart?'),
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
                  cart.clearCart();
                }
              },
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart(context, l10n, r)
          : Column(
              children: [
                Expanded(
                  child: r.constrainedContent(
                    child: ListView.separated(
                      padding: EdgeInsets.all(r.horizontalPadding),
                      itemCount: cart.items.length,
                      separatorBuilder: (_, __) => SizedBox(height: r.h(12)),
                      itemBuilder: (context, index) {
                        return CartItemTile(item: cart.items[index]);
                      },
                    ),
                  ),
                ),
                _buildOrderSummary(context, cart, locale, l10n, r),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(
      BuildContext context, AppLocalizations l10n, ResponsiveHelper r) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(r.horizontalPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: r.iconSize(100),
              color: Colors.grey.shade300,
            ),
            SizedBox(height: r.h(24)),
            Text(
              l10n.t('emptyCart'),
              style: TextStyle(
                fontSize: r.sp(22),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.h(8)),
            Text(
              l10n.t('emptyCartDesc'),
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
                      child: Text(l10n.t('startShopping'),
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
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    CartProvider cart,
    LocaleProvider locale,
    AppLocalizations l10n,
    ResponsiveHelper r,
  ) {
    return Container(
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: r.constrainedForm(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow(
                l10n.t('subtotal'),
                locale.formatPrice(cart.subtotal),
                r: r,
              ),
              SizedBox(height: r.h(8)),
              _buildSummaryRow(
                l10n.t('shipping'),
                cart.shipping == 0
                    ? l10n.t('free')
                    : locale.formatPrice(cart.shipping),
                valueColor: cart.shipping == 0 ? AppColors.success : null,
                r: r,
              ),
              SizedBox(height: r.h(8)),
              _buildSummaryRow(
                l10n.t('tax'),
                locale.formatPrice(cart.tax),
                r: r,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: r.h(12)),
                child: const Divider(),
              ),
              _buildSummaryRow(
                l10n.t('total'),
                locale.formatPrice(cart.total),
                isBold: true,
                fontSize: r.sp(18),
                r: r,
              ),
              SizedBox(height: r.h(16)),
              SizedBox(
                width: double.infinity,
                height: r.buttonHeight,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.checkout),
                  child: Text(l10n.t('proceedToCheckout'),
                      style: TextStyle(fontSize: r.sp(15))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 14,
    Color? valueColor,
    required ResponsiveHelper r,
  }) {
    final fs = fontSize == 14 ? r.sp(14) : fontSize;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fs,
            color: isBold ? null : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: fs,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
