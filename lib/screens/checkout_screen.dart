import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/alert_dialogs.dart';
import '../widgets/payment_method_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'credit_card';

  final List<_PaymentOption> _paymentOptions = const [
    _PaymentOption(id: 'credit_card', icon: Icons.credit_card, labelKey: 'creditCard'),
    _PaymentOption(id: 'paypal', icon: Icons.account_balance_wallet, labelKey: 'paypal'),
    _PaymentOption(id: 'apple_pay', icon: Icons.apple, labelKey: 'applePay'),
    _PaymentOption(id: 'google_pay', icon: Icons.g_mobiledata, labelKey: 'googlePay'),
    _PaymentOption(id: 'cod', icon: Icons.local_shipping_outlined, labelKey: 'cashOnDelivery'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = Provider.of<CartProvider>(context);
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('checkout'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address
            Text(
              l10n.t('shippingAddress'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                    ),
                    child: const Icon(Icons.location_on, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.profile.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user.profile.address}\n${user.profile.city}, ${user.profile.country} ${user.profile.zipCode}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.edit_outlined, color: Colors.grey.shade400, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Payment Methods
            Text(
              l10n.t('paymentMethod'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(_paymentOptions.length, (index) {
              final option = _paymentOptions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PaymentMethodCard(
                  label: l10n.t(option.labelKey),
                  icon: option.icon,
                  isSelected: _selectedPayment == option.id,
                  onTap: () => setState(() => _selectedPayment = option.id),
                ),
              );
            }),
            const SizedBox(height: 28),

            // Order Summary
            Text(
              l10n.t('orderSummary'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ...cart.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.product.name} x${item.quantity}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ),
                        Text(
                          locale.formatPrice(item.totalPrice),
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                      ],
                    ),
                  )),
                  const Divider(height: 20),
                  _summaryRow(l10n.t('subtotal'), locale.formatPrice(cart.subtotal)),
                  const SizedBox(height: 6),
                  _summaryRow(
                    l10n.t('shipping'),
                    cart.shipping == 0 ? l10n.t('free') : locale.formatPrice(cart.shipping),
                  ),
                  const SizedBox(height: 6),
                  _summaryRow(l10n.t('tax'), locale.formatPrice(cart.tax)),
                  const Divider(height: 20),
                  _summaryRow(l10n.t('total'), locale.formatPrice(cart.total), isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
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
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final confirmed = await AppAlertDialogs.showPlaceOrderDialog(context);
                if (confirmed == true && context.mounted) {
                  final orderProvider =
                      Provider.of<OrderProvider>(context, listen: false);
                  final selectedLabel = _paymentOptions
                      .firstWhere((o) => o.id == _selectedPayment)
                      .labelKey;
                  final order = orderProvider.placeOrder(
                    items: cart.items,
                    totalAmount: cart.total,
                    paymentMethod: l10n.t(selectedLabel),
                  );
                  cart.clearCart();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.orderConfirmation,
                      (route) => false,
                      arguments: order,
                    );
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.t('placeOrder')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? null : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PaymentOption {
  final String id;
  final IconData icon;
  final String labelKey;

  const _PaymentOption({
    required this.id,
    required this.icon,
    required this.labelKey,
  });
}
