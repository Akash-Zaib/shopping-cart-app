import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/order.dart';
import '../providers/locale_provider.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final orders = Provider.of<OrderProvider>(context);
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    final r = ResponsiveHelper(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('orderHistory'))),
      body: orders.orders.isEmpty
          ? _buildEmpty(context, l10n, r)
          : r.constrainedContent(
              child: ListView.separated(
                padding: EdgeInsets.all(r.horizontalPadding),
                itemCount: orders.orders.length,
                separatorBuilder: (_, __) => SizedBox(height: r.h(12)),
                itemBuilder: (context, index) {
                  final order = orders.orders[index];
                  return _buildOrderCard(context, order, locale, l10n, r);
                },
              ),
            ),
    );
  }

  Widget _buildEmpty(
      BuildContext context, AppLocalizations l10n, ResponsiveHelper r) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(r.horizontalPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long,
                size: r.iconSize(100), color: Colors.grey.shade300),
            SizedBox(height: r.h(24)),
            Text(
              l10n.t('noOrders'),
              style: TextStyle(
                  fontSize: r.sp(22), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: r.h(8)),
            Text(
              l10n.t('noOrdersDesc'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: r.sp(15)),
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
    ResponsiveHelper r,
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
      padding: EdgeInsets.all(r.cardPadding),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: r.sp(14),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: r.w(10), vertical: r.h(4)),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusRound),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: r.sp(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: r.h(10)),
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: r.iconSize(14), color: Colors.grey.shade500),
              SizedBox(width: r.w(6)),
              Text(
                DateFormat.yMMMd().format(order.orderDate),
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: r.sp(13)),
              ),
              SizedBox(width: r.w(16)),
              Icon(Icons.payment,
                  size: r.iconSize(14), color: Colors.grey.shade500),
              SizedBox(width: r.w(6)),
              Flexible(
                child: Text(
                  order.paymentMethod,
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: r.sp(13)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.itemCount} ${l10n.t('items')}',
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: r.sp(14)),
              ),
              Text(
                locale.formatPrice(order.totalAmount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: r.sp(16),
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
