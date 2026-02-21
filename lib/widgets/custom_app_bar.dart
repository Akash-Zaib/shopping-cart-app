import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';

class CartIconBadge extends StatelessWidget {
  const CartIconBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveHelper(context);

    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
          child: Padding(
            padding: EdgeInsets.only(right: r.w(8)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(r.w(8)),
                  child: Icon(Icons.shopping_bag_outlined,
                      size: r.iconSize(26)),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: r.w(2),
                    top: r.w(2),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(r.w(4)),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: r.w(18).clamp(16.0, 22.0),
                          minHeight: r.w(18).clamp(16.0, 22.0),
                        ),
                        child: Text(
                          cart.itemCount > 99 ? '99+' : '${cart.itemCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: r.sp(10),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
