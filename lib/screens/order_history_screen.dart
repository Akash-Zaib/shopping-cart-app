import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/order.dart';
import '../providers/locale_provider.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final orders = Provider.of<OrderProvider>(context);
    final locale = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('orderHistory'))),
      body: orders.orders.isEmpty
          ? _buildEmpty(context, l10n)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders.orders[index];
                return _buildOrderCard(context, order, locale, l10n);
              },
            ),
    );
  }

  Widget _buildEmpty(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 100, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            Text(
              l10n.t('noOrders'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.t('noOrdersDesc'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Order order,
    LocaleProvider locale,
    AppLocalizations l10n,
  ) {
    String statusText;
    Color statusColor;
    switch (order.status) {
      case OrderStatus.placed:
        statusText = l10n.t('placed');
        statusColor = AppColors.primary;
        break;
      case OrderStatus.confirmed:
        statusText = l10n.t('confirmed');
        statusColor = Colors.orange;
        break;
      case OrderStatus.shipped:
        statusText = l10n.t('shipped');
        statusColor = Colors.blue;
        break;
      case OrderStatus.delivered:
        statusText = l10n.t('delivered');
        statusColor = AppColors.success;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusRound),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                DateFormat.yMMMd().format(order.orderDate),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(width: 16),
              Icon(Icons.payment, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                order.paymentMethod,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.itemCount} ${l10n.t('items')}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              Text(
                locale.formatPrice(order.totalAmount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
