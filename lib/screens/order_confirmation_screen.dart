import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/order.dart';
import '../providers/locale_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;
    final l10n = AppLocalizations.of(context);
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    final r = ResponsiveHelper(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(r.horizontalPadding),
          child: r.constrainedForm(
            child: Column(
              children: [
                SizedBox(height: r.h(40)),

                // Animated Check
                _AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: r.iconSize(120),
                          height: r.iconSize(120),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: r.iconSize(80),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: r.h(24)),

                Text(
                  l10n.t('orderPlaced'),
                  style: GoogleFonts.poppins(
                    fontSize: r.sp(28),
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: r.h(8)),
                Text(
                  l10n.t('orderSuccess'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: r.sp(15),
                  ),
                ),
                SizedBox(height: r.h(32)),

                // Order Details Card
                Container(
                  padding: EdgeInsets.all(r.cardPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _detailRow(
                        Icons.receipt_long,
                        l10n.t('orderId'),
                        order.id,
                        r,
                      ),
                      const Divider(height: 24),
                      _detailRow(
                        Icons.calendar_today,
                        l10n.t('orderDate'),
                        DateFormat.yMMMd().add_jm().format(order.orderDate),
                        r,
                      ),
                      const Divider(height: 24),
                      _detailRow(
                        Icons.shopping_bag_outlined,
                        l10n.t('items'),
                        '${order.itemCount} ${l10n.t('items')}',
                        r,
                      ),
                      const Divider(height: 24),
                      _detailRow(
                        Icons.payment,
                        l10n.t('paymentMethod'),
                        order.paymentMethod,
                        r,
                      ),
                      const Divider(height: 24),
                      _detailRow(
                        Icons.attach_money,
                        l10n.t('total'),
                        locale.formatPrice(order.totalAmount),
                        r,
                        valueStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: r.sp(18),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: r.h(16)),

                // Status
                Container(
                  padding: EdgeInsets.all(r.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: r.iconSize(20)),
                      SizedBox(width: r.w(8)),
                      Text(
                        '${l10n.t('placed')} ✓',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: r.sp(16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: r.h(40)),

                // Buttons
                SizedBox(
                  width: double.infinity,
                  height: r.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: r.iconSize(18)),
                        SizedBox(width: r.w(8)),
                        Flexible(
                          child: Text(l10n.t('continueShopping'),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: r.sp(14))),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: r.h(12)),
                SizedBox(
                  width: double.infinity,
                  height: r.buttonHeight,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                      Navigator.pushNamed(context, AppRoutes.orderHistory);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt, size: r.iconSize(18)),
                        SizedBox(width: r.w(8)),
                        Flexible(
                          child: Text(l10n.t('viewOrders'),
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
        ),
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String label,
    String value,
    ResponsiveHelper r, {
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Icon(icon, size: r.iconSize(20), color: AppColors.primary),
        SizedBox(width: r.w(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: r.sp(12),
                ),
              ),
              SizedBox(height: r.h(2)),
              Text(
                value,
                style: valueStyle ??
                    TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: r.sp(14),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const _AnimatedBuilder({
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
